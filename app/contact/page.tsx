import Cover from "@/components/cover";
import ContactForm from "@/components/contact";

const ContactPage = () => {
  return (
    <div>
      <Cover />
      <div className="w-11/12 mx-auto">
        <div className="w-fit mx-auto mt-12 mb-6 font-bold text-2xl">
          Contact
        </div>
        <ContactForm />
      </div>
    </div>
  );
};

export default ContactPage;