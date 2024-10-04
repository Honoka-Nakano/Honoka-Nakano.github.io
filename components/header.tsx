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
    <header className="h-[70px] py-2 px-4">
      <div className="flex justify-between h-full">
        <div className="flex items-center font-bold text-4xl">
          <Link href="/">
            Hono
          </Link>
        </div>
        <div className="flex items-center">
          <DropdownMenu>
            <DropdownMenuTrigger>
              <Menu size={38} />
            </DropdownMenuTrigger>
            <DropdownMenuContent className="w-56">
              <DropdownMenuLabel>Menu</DropdownMenuLabel>
              <DropdownMenuSeparator />
              <DropdownMenuGroup>
                <Link href="/profile">
                  <DropdownMenuItem>
                    <User className="mr-2 h-4 w-4" />
                    <span>Profile</span>
                  </DropdownMenuItem>
                </Link>
                <Link href="/blogs">
                  <DropdownMenuItem>
                    <NotebookPen className="mr-2 h-4 w-4" />
                    <span>Blogs</span>
                  </DropdownMenuItem>
                </Link>
                <Link href="/dev">
                  <DropdownMenuItem>
                    <Code className="mr-2 h-4 w-4" />
                    <span>What I developed</span>
                  </DropdownMenuItem>
                </Link>
                <Link href="/contact">
                  <DropdownMenuItem>
                    <Mail className="mr-2 h-4 w-4" />
                    <span>Contact</span>
                  </DropdownMenuItem>
                </Link>
              </DropdownMenuGroup>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
    </header>
  );
};

export default Header;