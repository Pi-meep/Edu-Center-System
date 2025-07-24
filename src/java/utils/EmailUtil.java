/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;
import java.util.Random;

/**
 *
 * @author ASUS
 */

/**
 * Utility class để gửi email xác thực
 */
public class EmailUtil {
    
    private static final String FROM_EMAIL = "educenter3425@gmail.com"; // Thay bằng email của bạn
    private static final String PASSWORD = "dohx demr rfrt acqz"; // App password của Gmail
    
    /**
     * Tạo mã xác thực 6 số ngẫu nhiên
     */
    public static String generateVerificationCode() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(1000000));
    }
    
    /**
     * Gửi mã xác thực qua email
     */
    public static boolean sendVerificationCode(String toEmail, String verificationCode) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
                }
            });
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Ma xac thuc mat khau");
            
            String content = "<h2>Đặt lại mật khẩu</h2>" +
                           "<p>Mã xác thực của bạn là: <strong>" + verificationCode + "</strong></p>" +
                           "<p>Mã này có hiệu lực trong 10 phút.</p>" +
                           "<p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>";
            
            message.setContent(content, "text/html; charset=utf-8");
            
            Transport.send(message);
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
