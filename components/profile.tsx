import {
    FaJava,
    FaPython,
    FaGolang,
    FaGitAlt,
  } from "react-icons/fa6";
  import {
    SiNextdotjs,
    SiFlask,
    SiGithub,
    SiAwslambda,
    SiAmazonapigateway,
    SiHeroku,
    SiPostgresql,
    SiR,
    SiReact,
    SiRust,
    SiSwift,
    SiTypescript,
    SiLazyvim,
    SiApple,
  } from "react-icons/si";
  import {
    VscVscode,
  } from "react-icons/vsc";
  import Image from "next/image";
  import Link from "next/link";
  
  const Profile = () => {
    return (
      <div>
        <div className="w-fit mx-auto mt-12 mb-6 font-bold text-2xl md:text-3xl">
          Profile
        </div>
        <div className="space-y-16">
          <div className="container mx-auto md:flex md:my-10">
            <div className="w-fit mx-auto space-y-4 md:w-[30%] md:my-auto">
              <Image
                src={`/profile/icon.png`}
                alt="My icon"
                width={100}
                height={100}
                className="mx-auto"
              />
              <div className="flex font-bold text-lg space-x-1 md:block md:text-center md:text-xl md:space-x-0 md:space-y-1">
                <p>
                  Hono
                </p>
                <p>
                  (Keisuke Nakano)
                </p>
              </div>
            </div>
            <div className="w-5/6 mx-auto my-10 space-y-16 md:w-[70%] md:my-0 md:text-lg">
              <div className="space-y-6">
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
            </div>
          </div>
          <div className="space-y-16 mx-auto w-fit md:grid md:grid-cols-2 md:space-y-0 md:gap-12">
            <div className="space-y-6">
              <div className="font-bold text-center">Favorite Skills & Techs</div>
              <div className="flex w-fit mx-auto space-x-4">
                <Link href="https://www.typescriptlang.org/" target="_blank">
                  <SiTypescript size={48} />
                </Link>
                <Link href="https://www.python.org/" target="_blank">
                  <FaPython size={48} />
                </Link>
                <Link href="https://www.r-project.org/" target="_blank">
                  <SiR size={48} />
                </Link>
                <Link href="https://ja.react.dev/" target="_blank">
                  <SiReact size={48} />
                </Link>
                <Link href="https://nextjs.org/" target="_blank">
                  <SiNextdotjs size={48} />
                </Link>
                <Link href="https://flask.palletsprojects.com/en/3.0.x/" target="_blank">
                  <SiFlask size={48} />
                </Link>
              </div>
            </div>
            <div className="space-y-6">
              <div className="font-bold text-center">My Toolkit</div>
              <div className="flex w-fit mx-auto space-x-4">
                <Link href="https://git-scm.com/" target="_blank">
                  <FaGitAlt size={48} />
                </Link>
                <Link href="https://github.co.jp/" target="_blank">
                  <SiGithub size={48} />
                </Link>
                <Link href="https://code.visualstudio.com/" target="_blank">
                  <VscVscode size={48} />
                </Link>
                <Link href="https://www.lazyvim.org/" target="_blank">
                  <SiLazyvim size={48} />
                </Link>
                <Link href="https://www.apple.com/jp/" target="_blank">
                  <SiApple size={48} />
                </Link>
              </div>
            </div>
            <div className="space-y-6">
              <div className="font-bold text-center">What I Know</div>
              <div className="flex w-fit mx-auto space-x-4">
                <Link href="https://www.java.com/ja/" target="_blank">
                  <FaJava size={48} />
                </Link>
                <Link href="https://aws.amazon.com/jp/lambda/" target="_blank">
                  <SiAwslambda size={48} />
                </Link>
                <Link href="https://aws.amazon.com/jp/api-gateway/" target="_blank">
                  <SiAmazonapigateway size={48} />
                </Link>
                <Link href="https://jp.heroku.com/" target="_blank">
                  <SiHeroku size={48} />
                </Link>
              </div>
            </div>
            <div className="space-y-6">
              <div className="font-bold text-center">What I wanna learn</div>
              <div className="flex w-fit mx-auto space-x-4">
                <Link href="https://go.dev/" target="_blank">
                  <FaGolang size={48} />
                </Link>
                <Link href="https://www.rust-lang.org/ja" target="_blank">
                  <SiRust size={48} />
                </Link>
                <Link href="https://www.apple.com/jp/swift/" target="_blank">
                  <SiSwift size={48} />
                </Link>
                <Link href="https://www.postgresql.org/" target="_blank">
                  <SiPostgresql size={48} />
                </Link>
              </div>
            </div>
          </div>
        </div>
        <div className="mt-16 text-sm text-slate-500 md:text-base">
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
            <p className="w-full flex">
            <Link
              href="https://undraw.co/"
              className="text-blue-500 underline"
              target="_blank">
                unDraw
            </Link>
            <p className="mr-1">,</p>
            <Link
              href="https://react-icons.github.io/react-icons/"
              className="text-blue-500 underline"
              target="_blank">
              react icons
            </Link>
  
            </p>
          </div>
        </div>
      </div>
    );
  };
  
  export default Profile;