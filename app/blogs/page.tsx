import Cover from "@/components/cover";
import fs from "fs";
import path from "path";
import Link from "next/link";
import matter from "gray-matter";

export default async function BlogPage() {
  const blogDir = path.join("blogs");
  const directories = fs.readdirSync(blogDir);

  const validDirectories = directories.filter((slug) => {
    const markdownPath = path.join(blogDir, slug, `${slug}.md`);
    return fs.existsSync(markdownPath);
  });

  const posts = validDirectories.map((slug) => {
    const markdownPath = path.join(blogDir, slug, `${slug}.md`);
    const markdownWithMeta = fs.readFileSync(markdownPath, "utf-8");
    const { data: frontMatter} = matter(markdownWithMeta);

    return {
      slug,
      title: frontMatter.title,
      tags: frontMatter.tags,
      updated_at: frontMatter.updated_at,
      created_at: frontMatter.created_at,
    };
  });

  return (
    <div>
      <Cover />
      <div>
        <div className="w-fit mx-auto mt-12 mb-6 font-bold text-2xl md:text-3xl">
          Blogs
        </div>
        <div className="">
          <ul className="w-11/12 mx-auto space-y-6">
            {posts.map((post) => (
              <li key={post.slug}>
                <Link href={`/blogs/${post.slug}`}>
                  <div className="px-2 py-2 rounded shadow-xl">
                    <div className="font-bold text-lg">{post.title}</div>
                    {post.tags && (
                      <div className="m-1 space-x-2">
                        {post.tags.map((tag: string, index: number) => (
                          <span key={index} className="px-1 py-[2px] text-gray-600 bg-slate-200 rounded">{tag}</span>
                        ))}
                      </div>
                    )}
                    <div className="text-sm text-slate-500">更新日: {post.updated_at} | 作成日: {post.created_at}</div>
                  </div>
                </Link>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};