package com.company.safaqatek

import com.company.safaqtek.GMailSender
import com.company.safaqtek.SendEmail
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterFragmentActivity() {
    private val  SEND_EMAIL_CHANNEL = "com.company.safaqtek/sendEmail"
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,SEND_EMAIL_CHANNEL)

        channel.setMethodCallHandler{call, result ->
        if ((call.method == "SendEmail")){
            var arguments = call.arguments() as Map<String, String>
            val recipient = arguments["recipient"]
            val subject = arguments["subject"]
            val body = arguments["body"]


//            val sender = GMailSender(
//                    "no-replay@safaqatek.com",
//                    "Safaq@tek2022")
//
            val thread = Thread {
                try {
//                    sender.sendMail(subject, body,"no-replay@safaqatek.com",recipient);
                    val sendEmail =  SendEmail();
                    sendEmail.sendMail(recipient,
                            subject,
                            body);
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }

            thread.start()

        }
        }
    }



}
