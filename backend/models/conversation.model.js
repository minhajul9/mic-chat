import mongoose from "mongoose";

const conversationSchema = new mongoose.Schema({
    participants: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User"
        }
    ],
    lastMessageTime: {
        type: Date,
    },
    lastSenderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    lastMessage: {
        type: String
    },
    isRead: {
        type: Boolean,
        default: false
    }
}, { timestamps: true })


const Conversation = mongoose.model("Conversation", conversationSchema);

export default Conversation;