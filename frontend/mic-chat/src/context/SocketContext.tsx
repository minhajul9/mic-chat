/* eslint-disable @typescript-eslint/ban-ts-comment */
import { createContext, useEffect, useState } from "react";
import { useAuthContext } from "./AuthContext";
import { io } from "socket.io-client";

//@ts-ignore
export const SocketContext = createContext();

//@ts-ignore
export const SocketContextProvider = ({ children }) => {

    const [socket, setSocket] = useState(null);
    const [onlineUsers, setOnlineUsers] = useState([]);
    const { authUser } = useAuthContext();

    useEffect(() => {
        if (authUser) {
            const socket = io("http://localhost:5004");

            setSocket(socket);

            return () => socket.close();
        }
        else {
            socket.close();
            setSocket(null);
        }
    }, [])

    return (<SocketContext.Provider value={{ socket, onlineUsers }}>
        {children}
    </SocketContext.Provider>)
}