"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { z } from "zod";
import { useForm, SubmitHandler } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Loader2 } from "lucide-react";
import { submitForm } from "@/actions/form";
import toast from "react-hot-toast";

const schema = z.object({
  name: z.string().min(2, { message: "Name is required." }),
  email: z.string().email({ message: "Invalid email address." }),
  message: z.string().min(1, { message: "Message is required." }),
});
type InputType = z.infer<typeof schema>;

const ContactForm = () => {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);

  const form = useForm<InputType>({
    resolver: zodResolver(schema),
    defaultValues: {
      name: "",
      email: "",
      message: "",
    },
  });

  const onSubmit: SubmitHandler<InputType> = async (data) => {
    setIsLoading(true);
    try {
      const res = await submitForm({
        name: data.name,
        email: data.email,
        message: data.message,
      });

      if (!res.success) {
        toast.error("送信に失敗しました");
        return;
      }

      toast.success("問い合わせを送信しました");
      router.push("/");
      router.refresh();
    } catch (error) {
      toast.error("送信に失敗しました");
      console.log(error);
    } finally {
      setIsLoading(false);
    };
  }


  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        <FormField
          name="name"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="font-bold">Name:</FormLabel>
              <FormControl>
                <Input placeholder="Your name" {...field} />
              </FormControl>
              <FormMessage>{form.formState.errors.name?.message}</FormMessage>
            </FormItem>
          )}
        />
        <FormField
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="font-bold">Email:</FormLabel>
              <FormControl>
                <Input placeholder="Your email" {...field} />
              </FormControl>
              <FormMessage>{form.formState.errors.email?.message}</FormMessage>
            </FormItem>
          )}
        />
        <FormField
          name="message"
          render={({ field }) => (
            <FormItem>
              <FormLabel className="font-bold">Message:</FormLabel>
              <FormControl>
                <Textarea placeholder="Your message" {...field} />
              </FormControl>
              <FormMessage>{form.formState.errors.message?.message}</FormMessage>
            </FormItem>
          )}
        />
        <div className="w-fit mx-auto">
          <Button type="submit" disabled={isLoading} className="font-bold">
            {isLoading && <Loader2 className="mr-2 animate-spin" />}
            Send Message
          </Button>
        </div>
      </form>
    </Form>
  )
}

export default ContactForm;