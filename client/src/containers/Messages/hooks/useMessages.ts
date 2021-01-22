import { Empty } from "google-protobuf/google/protobuf/empty_pb";
import { useState, useEffect } from "react";
import { MessengerClient } from "messenger/MessengerServiceClientPb";

export const useMessages = (client: MessengerClient) => {
  const [messages, setMessages] = useState<string[]>([]);

  useEffect(() => {
    const stream$ = client.getMessages(new Empty());
    stream$.on("data", (m: { getMessage: () => any; }) => {
      setMessages((state: any) => [...state, m.getMessage()]);
    });
  }, [client]);

  return {
    messages
  };
};