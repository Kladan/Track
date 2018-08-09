package com.teambuktu.mqtt;

import org.springframework.stereotype.Component;

@Component
public class Receiver {

    public void receiveMessage(byte[] message) {
        System.out.println("Received <" + new String(message) + ">");
    }

}