import admin from "../firebase/firebase.js";


export const sendMessageNotification = async (registrationToken, title, body, messageData) => {
    const message = {
        token: registrationToken,
        notification: {
            title: title,
            body: body,
        },
        data: { type: 'message', message: JSON.stringify(messageData) },

    };

    try {
        const response = await admin.messaging().send(message);
        console.log('Successfully sent message:', response);
    } catch (error) {
        console.error('Error sending message:', error);
    }
}

export const sendNewConversationNotification = async (registrationToken, title, body, messageData) => {
    const message = {
        token: registrationToken,
        notification: {
            title: title,
            body: body,
        },
        data: { type: 'message', message: JSON.stringify(messageData) },

    };

    try {
        const response = await admin.messaging().send(message);
        console.log('Successfully sent message:', response);
    } catch (error) {
        console.error('Error sending message:', error);
    }
}