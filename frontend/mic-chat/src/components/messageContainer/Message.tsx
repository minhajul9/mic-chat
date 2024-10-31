import { useAuthContext } from "../../context/AuthContext"
import useConversation from "../../zustand/useConversation";

const Message = ({ message }) => {

    const { authUser } = useAuthContext();
    const { selectedConversation } = useConversation();
    const fromMe = message.senderId === authUser._id;

    return (
        <div className={`chat ${fromMe ? "chat-end" : "chat-start"}`}>
            <div className="chat-image avatar">
                <div className="w-10 rounded-full">
                    <img
                        alt="Tailwind CSS chat bubble component"
                        src={fromMe ? authUser.profilePic : selectedConversation?.profilePic} />
                </div>
            </div>
            <div className="chat-header">
                Anakin
                <time className="text-xs opacity-50">12:46</time>
            </div>
            <div className={`chat-bubble text-white ${fromMe ? 'bg-blue-500' : ''}`}>{message.message}</div>
            <div className="chat-footer opacity-50">Seen at 12:46</div>
        </div>
    )
}

export default Message