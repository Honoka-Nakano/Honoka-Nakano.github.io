import Cover from "@/components/cover";
import fs from "fs";
import path from "path";
import Link from "next/link";
import matter from "gray-matter";

export default async function BlogPage() {
  const blogDir = path.join("blogs");
  const directories = fs.readdirSync(blogDir);

  const posts = directories.map((slug) => {
    const markdownPath = path.join(blogDir, slug, `${slug}.md`);
    const markdownWithMeta = fs.readFileSync(markdownPath, "utf-8");
    const { data: frontMatter} = matter(markdownWithMeta);

    return {
      slug,
      title: frontMatter.title,
    };
  });

  return (
    <div>
      <Cover />
      <div>
        <div className="w-fit mx-auto mt-12 mb-6 font-bold text-2xl">
          Blogs
        </div>
        <div>
          <ul>
            {posts.map((post) => (
              <li key={post.slug}>
                <Link href={`/blogs/${post.slug}`}>
                  {post.title}
                </Link>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};