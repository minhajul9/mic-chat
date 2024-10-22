import React, { useState } from 'react'
import toast from 'react-hot-toast';
import { useAuthContext } from '../context/AuthContext';

const useLogin = () => {
    const [loading, setLoading] = useState(false);
    const { setAuthUser } = useAuthContext();

    const login = async (username, password) => {
        setLoading(true)

        try {

            const res = await fetch('/api/auth/login', {
                method: "POST",
                headers: {
                    'content-type': "application/json"
                },
                body: JSON.stringify({ username, password })
            });

            console.log('res done')
            const data = await res.json();

            console.log(data)

            if (data.error) {
                throw new Error(data.message)
            }

            localStorage.setItem("chat-user", JSON.stringify(data))
            setAuthUser(data);

        } catch (error) {
            toast.error(error.message);
        }
        finally {
            setLoading(false);
        }

    }

    return { loading, login };
}

export default useLogin