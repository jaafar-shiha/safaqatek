package com.company.safaqtek;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendEmail {
	public SendEmail() {
	}

	public synchronized void sendMail(String recipient, String subject, String body){
		Properties props;
		Session session;
		MimeMessage message;

		props = new Properties();
		props.put("mail.smtp.host", "safaqatek.com");
		props.put("mail.smtp.port", "465");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.socketFactory.port", "465");
		props.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
		props.put("mail.smtp.starttls.enable", "true");

		Authenticator auth = new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(
						"no-replay@safaqatek.com",
						"Safaq@tek2022"
				);
			}
		};

		session = Session.getInstance(props, auth);

		try {

			InternetAddress[] recipients = new InternetAddress[1];
			recipients[0] = new InternetAddress(recipient);
			//recipients[1] = new InternetAddress("recipient1@hotmail.com");
			//recipients[2] = new InternetAddress("recipient2@domainname.com");
			//recipients[3] = new InternetAddress("recipient3@somedomain.ch");
			//recipients[4] = new InternetAddress("recipient4@gtv.org");
			// ...

			message = new MimeMessage(session);
			message.setFrom(new InternetAddress("no-replay@safaqatek.com"));
			message.addRecipients(Message.RecipientType.TO, recipients);
			message.setSubject(subject);
			message.setText(body);

			Transport.send(message);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}
}
