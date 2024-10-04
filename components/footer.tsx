import Link from "next/link";
import Image from "next/image";

const Footer = () => {
  return (
    <footer className="h-fit mt-8 p-2 space-y-4 bg-slate-600">
      <div className="flex w-fit mx-auto text-white space-x-2">
        <p className="font-bold">
          &copy; Honoka Nakano.
        </p>
        <p>
          All rights reserved.
        </p>
      </div>
      <div className="flex items-center w-fit mx-auto">
        <ul className="flex space-x-4">
          <li>
            <Link href="https://x.com/hono_n819/" target="_blank">
              <Image
                src={`/X/X_white.png`}
                alt="X logo"
                width={30}
                height={30}
              />
            </Link>
          </li>
          <li>
            <Link href="https://github.com/Honoka-Nakano/" target="_blank">
              <Image
                src={`/github/github.png`}
                alt="Github logo"
                width={30}
                height={30}
              />
            </Link>
          </li>
          <li>
            <Link href="https://qiita.com/Honoka-Nakano/" target="_blank">
              <Image
                src={`/qiita/qiita.png`}
                alt="Qiita logo"
                width={30}
                height={30}
              />
            </Link>
          </li>
          <li>
            <Link href="https://zenn.dev/honokanakano" target="_blank">
              <Image
                src={`/zenn/zenn.png`}
                alt="Zenn logo"
                width={30}
                height={30}
              />
            </Link>
          </li>
        </ul>
      </div>
    </footer>
  );
};

export default Footer;