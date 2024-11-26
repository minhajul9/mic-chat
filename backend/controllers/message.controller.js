import Conversation from "../models/conversation.model.js";
import Message from "../models/message.model.js";
import User from "../models/user.model.js";
import { sendMessageNotification, sendNewConversationNotification } from "../notification/notification.js";
import { getReceiverSocketId, io } from "../socket/socket.js";
import { ObjectId } from 'mongodb'

export const sendMessage = async (req, res) => {
    try {
        const message = req.body;
        const conversationId = req.params.id;
        const senderId = req.decoded._id
        const receiverId = message.receiverId;
        const senderName = message.senderName;

        console.log('sending message')
        let conversation = await Conversation.findById(conversationId)

        const newMessage = new Message(message)

        if (newMessage) {


            conversation.isRead = false;
            conversation.lastMessageTime = new Date();
            conversation.lastMessage = newMessage.message;
            conversation.lastSenderId = senderId;
        }

        await Promise.all([conversation.save(), newMessage.save()])

        const receiver = await User.findById(receiverId);

        await sendMessageNotification(receiver.fcmToken, senderName, "sent a message.", newMessage);


        res.send({ message: newMessage, conversation, error: false })


    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.send({ error: true, message: "Internal server error." })
    }
}

export const sendFirstMessage = async (req, res) => {
    try {

        const message = req.body;
        const receiverId = message.receiverId;
        const senderId = req.decoded._id;

        const senderName = message.senderName;

        let newConversation = false;

        let conversation = await Conversation.findOne({
            participants: { $all: [senderId, receiverId] }
        })

        if (!conversation) {
            newConversation = true;
            conversation = await Conversation.create({
                participants: [senderId, receiverId]
            })
        }

        const newMessage = await Message.create({
            senderId,
            receiverId,
            conversationId: conversation._id,
            message: message.message
        })

        if (newMessage) {


            conversation.isRead = false;
            conversation.lastMessageTime = new Date();
            conversation.lastMessage = newMessage.message;
            conversation.lastSenderId = senderId;

            // conversation.save();
        }

        await Promise.all([conversation.save(), newMessage.save()])

        const receiver =  await User.findById(receiverId).select('-password');

        conversation.participants = [receiver];

        await sendNewConversationNotification(receiver.fcmToken, senderName, "sent a message.", {conversation, newMessage});



        res.json({ message: newMessage, conversation, error: false })


    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.json({ error: true, message: "Internal server error." })
    }
}

export const getMessages = async (req, res) => {
    try {

        let messages;

        const conversationId = new ObjectId(req.params.id);
        const conversation = await Conversation.findById(conversationId);
        // console.log(conversation);

        if (!conversation) return res.send({ error: false, messages: [] });

        else {
            messages = await Message.find({ conversationId: conversationId }).sort({createdAt: -1});
            // console.log(messages);
        }

        if(conversation.lastSenderId == req.decoded._id);{
            conversation.isRead = true;

            await conversation.save();
        }

        

        res.send({ error: false, messages });
    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.send({ error: true, message: "Internal server error." })
    }
}

export const checkMessages = async (req, res) => {
    try {

        const { id } = req.params;
        const senderId = req.decoded._id;

        const conversation = await Conversation.findOne({
            participants: {
                $all: [senderId, id]
            }
        })

        if (!conversation) return res.send({ messages: [], conversation: null });
        const messages = await Message.find({
            conversationId: conversation._id
        })

        res.send({ messages, conversation, error: false });
    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.send({ error: true, message: "Internal server error." })
    }
}
