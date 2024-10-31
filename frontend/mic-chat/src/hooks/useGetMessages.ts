import { useEffect, useState } from "react"
import useConversation from "../zustand/useConversation";
import toast from "react-hot-toast";

const useGetMessages = () => {

    const [loading, setLoading] = useState(false);
    // @ts-ignore
    const { messages, setMessages, selectedConversation } = useConversation();

    useEffect(() => {
        // @ts-ignore
        const getMessages = async () => {
            setLoading(true)

            try {
                const res = await fetch(`/api/messages/${selectedConversation._id}`);
                const data = await res.json();

                if (data.error) {
                    console.log("from get messages", data)
                    throw new Error(data.message)}

                setMessages(data)
            } catch (error) {
                // @ts-ignore
                toast.error(error.message);
            }
            finally {
                setLoading(false);
            }
        }

        if (selectedConversation?._id) getMessages();
    }, [selectedConversation?._id, setMessages])

    return { messages, loading };

}

export default useGetMessages