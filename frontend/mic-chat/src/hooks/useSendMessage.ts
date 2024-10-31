import { useState } from "react"
import useConversation from "../zustand/useConversation";
import toast from "react-hot-toast";

const useSendMessage = () => {

    const [loading, setLoading] = useState(false);
    // @ts-ignore
    const { messages, setMessages, selectedConversation } = useConversation();

    // @ts-ignore
    const sendMessage = async (message) => {

        setLoading(true);

        try {

            const res = await fetch(`/api/messages/send/${selectedConversation._id}`, {
                method: "POST",
                headers: {
                    'content-type': 'application/json'
                },
                body: JSON.stringify({ message })
            })

            const data = await res.json();

            if (data.error) {
                throw new Error(data.message)
            }

            setMessages([...messages, data])


        } catch (error) {
            // @ts-ignore
            toast.error(error.message);
        }
        finally {
            setLoading(false);
        }
    }

    return { sendMessage, loading };

}

export default useSendMessage