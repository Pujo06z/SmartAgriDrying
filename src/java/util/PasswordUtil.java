/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 *
 * @author ADMIN
 */
public class PasswordUtil {
      private static final int ITERATIONS = 65536;
    private static final int KEY_LENGTH = 256;


    // =========================================
    // HASH PASSWORD
    // =========================================
    public static String hashPassword(String password)
            throws NoSuchAlgorithmException,
            InvalidKeySpecException {

        byte[] salt = new byte[16];

        SecureRandom random
                = new SecureRandom();

        random.nextBytes(salt);


        PBEKeySpec spec
                = new PBEKeySpec(
                        password.toCharArray(),
                        salt,
                        ITERATIONS,
                        KEY_LENGTH
                );


        SecretKeyFactory factory
                = SecretKeyFactory.getInstance(
                        "PBKDF2WithHmacSHA1"
                );


        byte[] hash
                = factory.generateSecret(spec)
                        .getEncoded();


        return ITERATIONS
                + ":"
                + Base64.getEncoder()
                        .encodeToString(salt)
                + ":"
                + Base64.getEncoder()
                        .encodeToString(hash);
    }


    // =========================================
    // VERIFY PASSWORD
    // =========================================
    public static boolean verifyPassword(
            String password,
            String storedPassword)
            throws NoSuchAlgorithmException,
            InvalidKeySpecException {

        String[] parts
                = storedPassword.split(":");


        if (parts.length != 3) {
            return false;
        }


        int iterations
                = Integer.parseInt(parts[0]);


        byte[] salt
                = Base64.getDecoder()
                        .decode(parts[1]);


        byte[] storedHash
                = Base64.getDecoder()
                        .decode(parts[2]);


        PBEKeySpec spec
                = new PBEKeySpec(
                        password.toCharArray(),
                        salt,
                        iterations,
                        storedHash.length * 8
                );


        SecretKeyFactory factory
                = SecretKeyFactory.getInstance(
                        "PBKDF2WithHmacSHA1"
                );


        byte[] testHash
                = factory.generateSecret(spec)
                        .getEncoded();


        if (testHash.length != storedHash.length) {
            return false;
        }


        int diff = 0;

        for (int i = 0;
                i < storedHash.length;
                i++) {

            diff
                    |= storedHash[i]
                    ^ testHash[i];
        }


        return diff == 0;
    }
    

}

