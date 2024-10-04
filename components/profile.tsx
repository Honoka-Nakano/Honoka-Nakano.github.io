import Image from "next/image";
import Link from "next/link";

const Profile = () => {
  return (
    <div>
      <div className="w-fit mx-auto mt-12 mb-6 font-bold text-2xl">
        Profile
      </div>
      <div className="w-fit mx-auto space-y-4">
        <Image
          src={`/profile/icon.png`}
          alt="My icon"
          width={100}
          height={100}
          className="mx-auto"
        />
        <div className="font-bold text-lg">
          Hono (Keisuke Nakano)
        </div>
      </div>
      <div className="w-5/6 mx-auto my-10 space-y-6">
        <div className="flex space-x-2">
          <div className="w-fit">
            <Image
              src={`/profile/student.png`}
              alt="student"
              width={80}
              height={80}
            />
          </div>
          <div className="flex items-center flex-1">
            <p>
              Hi there, I&apos;m a student of Kochi University of Technology.
            </p>
          </div>
        </div>
        <div className="flex space-x-2">
          <div className="w-fit">
            <Image
              src={`/profile/economics.png`}
              alt="economics"
              width={80}
              height={80}
            />
          </div>
          <div className="flex items-center flex-1">
            <p>
              I&apos;m majoring in economics & statistics.
            </p>
          </div>
        </div>
        <div className="flex space-x-2">
          <div className="w-fit">
            <Image
              src={`/profile/laboratory.png`}
              alt="laboratory"
              width={80}
              height={80}
            />
          </div>
          <div className="flex items-center flex-1">
            <p>
              And I belong to the Laboratory for Quantitive Political Economy.
            </p>
          </div>
        </div>
        <div className="flex space-x-2">
          <div className="w-fit">
            <Image
              src={`/profile/web.png`}
              alt="web"
              width={80}
              height={80}
            />
          </div>
          <div className="flex items-center flex-1">
            <p>
              I&apos;m currently learning web development with AWS, React(Next.js) & Flask!
            </p>
          </div>
        </div>
      </div>
      <div className="text-sm text-slate-500">
        <div className="flex space-x-2">
          <p className="w-full text-right">
            Icon:
          </p>
          <Link
            href="https://lit.link/sk3148"
            className="text-blue-500 underline w-full"
            target="_blank">
              yayoi seki
          </Link>
        </div>
        <div className="flex space-x-2">
          <p className="w-full text-right">
            Source:
          </p>
          <Link
            href="https://undraw.co/"
            className="text-blue-500 underline w-full"
            target="_blank">
              unDraw
          </Link>
        </div>
      </div>
    </div>
  );
};

export default Profile;