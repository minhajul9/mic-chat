import { useState } from 'react'
import toast from 'react-hot-toast';
import { useAuthContext } from '../context/AuthContext';

const useLogout = () => {
    const [loading, setLoading] = useState(false);

    const { setAuthUser } = useAuthContext();

    const logout = async () => {
        setLoading(true)
        try {

            const res = await fetch('/api/auth/logout', {
                method: "POST",
                headers: {
                    "content-type": "application/json"
                }
            });

            const data = res.json();

            if (data.error) {
                toast.error(data.message);
            }
            else {

                localStorage.removeItem("chat-user")
                setAuthUser(null)
            }

        } catch (error) {
            toast.error(error.message);
        }
        finally {
            setLoading(false);
        }
    }

    return { loading, logout }
}

export default useLogout