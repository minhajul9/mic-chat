/* eslint-disable @typescript-eslint/ban-ts-comment */
import { createContext, useContext, useEffect, useState } from "react";
import { useAuthContext } from "./AuthContext";
import { io } from "socket.io-client";

//@ts-ignore
export const SocketContext = createContext();

export const useSocketContext = () => {
    return useContext(SocketContext);
}

//@ts-ignore
export const SocketContextProvider = ({ children }) => {

    const [socket, setSocket] = useState(null);
    const [onlineUsers, setOnlineUsers] = useState([]);
    const { authUser } = useAuthContext();

    useEffect(() => {
        if (authUser) {
            const socket = io("http://localhost:5004",{
                query: {
                    userId : authUser._id
                }
            });

            setSocket(socket);

            socket.on("getOnlineUsers", (users) =>{
                console.log(users);
                setOnlineUsers(users);
            })

            return () => socket.close();
        }
        else {
            socket.close();
            setSocket(null);
        }
    }, [authUser])

    return (<SocketContext.Provider value={{ socket, onlineUsers }}>
        {children}
    </SocketContext.Provider>)
}