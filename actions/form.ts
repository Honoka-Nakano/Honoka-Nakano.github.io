"use server";

import { headers } from "next/headers";

interface SubmitFormType {
  name: string,
  email: string,
  message: string,
};

export const submitForm = async({
  name,
  email,
  message,
}: SubmitFormType) => {
  const body = JSON.stringify({
    name: name,
    email: email,
    message: message,
  });
  const options = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body,
  };

  const response = await fetch("/", options);
  if (!response.ok) {
    const errorData = await response.json();
    return { success: false, error: errorData};
  }

  const contentType = response.headers.get("Content-Type");
  if (contentType && contentType.includes("application/json")) {
    const data = await response.json();
    return { success: true, data };
  }

  return { success: true };
}