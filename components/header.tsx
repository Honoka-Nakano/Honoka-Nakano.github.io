import {
    Menu,
    User,
    NotebookPen,
    Code,
    Mail,
  } from "lucide-react";
  import {
    DropdownMenu,
    DropdownMenuTrigger,
    DropdownMenuContent,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuGroup,
    DropdownMenuItem,
  } from "@/components/ui/dropdown-menu";
  import Link from "next/link";
  
  const Header = () => {
    return (
      <header className="container h-[70px] py-2 px-4 mx-auto md:mx-auto">
        <div className="flex justify-between h-full">
          <div className="flex items-center font-bold text-4xl">
            <Link href="/">
              Hono
            </Link>
          </div>
          {/* Mobile */}
          <div className="flex items-center md:hidden">
            <DropdownMenu>
              <DropdownMenuTrigger>
                <Menu size={38} />
              </DropdownMenuTrigger>
              <DropdownMenuContent className="w-60 font-bold">
                <DropdownMenuLabel className="text-lg">Menu</DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuGroup>
                  <Link href="/profile">
                    <DropdownMenuItem>
                      <User className="mr-2 h-4 w-4" />
                      <span className="text-lg">Profile</span>
                    </DropdownMenuItem>
                  </Link>
                  <Link href="/blogs">
                    <DropdownMenuItem>
                      <NotebookPen className="mr-2 h-4 w-4" />
                      <span className="text-lg">Blogs</span>
                    </DropdownMenuItem>
                  </Link>
                  <Link href="/dev">
                    <DropdownMenuItem>
                      <Code className="mr-2 h-4 w-4" />
                      <span className="text-lg">What I developed</span>
                    </DropdownMenuItem>
                  </Link>
                  <Link href="/contact">
                    <DropdownMenuItem>
                      <Mail className="mr-2 h-4 w-4" />
                      <span className="text-lg">Contact</span>
                    </DropdownMenuItem>
                  </Link>
                </DropdownMenuGroup>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
          {/* Tablet, PC */}
          <div className="hidden md:block">
            <ul className="h-full flex items-center space-x-6 text-lg">
              <li>
                <Link href="/profile" className="flex space-x-1 hover:text-sky-700">
                  <User className="h-full " />
                  <span>Profile</span>
                </Link>
              </li>
              <li>
                <Link href="/blogs" className="flex space-x-1 hover:text-sky-700">
                  <NotebookPen className="h-full" />
                  <span>Blogs</span>
                </Link>
              </li>
              <li>
                <Link href="/dev" className="flex space-x-1 hover:text-sky-700">
                  <Code className="h-full" />
                  <span>What I developed</span>
                </Link>
              </li>
              <li>
                <Link href="/contact" className="flex space-x-1 hover:text-sky-700">
                  <Mail className="h-full" />
                  <span>Contact</span>
                </Link>
              </li>
            </ul>
          </div>
        </div>
      </header>
    );
  };
  
  export default Header;