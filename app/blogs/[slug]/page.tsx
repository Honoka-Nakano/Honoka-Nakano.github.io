import fs from "fs";
import path from "path";
import matter from "gray-matter";
import { remark } from "remark";
import remarkRehype from "remark-rehype";
import rehypeStringify from "rehype-stringify";
import rehypeHighlight from "rehype-highlight";
// import "highlight.js/styles/github-dark.css";
import rehypeSlug from "rehype-slug";
import r from "highlight.js/lib/languages/r";
import Cover from "@/components/cover";

interface Params {
  params: {
    slug: string;
  };
}

export async function generateStaticParams() {
  const blogDir = path.join("blogs");
  const directories = fs.readdirSync(blogDir);

  const paths = directories.map((slug) => ({
    slug,
  }));

  return paths;
}

export default async function BlogPost({ params }: Params) {
  const { slug } = params;

  const markdownPath = path.join("blogs", slug, `${slug}.md`);
  const markdownWithMeta = fs.readFileSync(markdownPath, "utf-8");
  const { data: frontMatter, content } = matter(markdownWithMeta);

  const toc: Array<{ text: string, id: string, level: number}> = [];

  const processedContent = await remark()
    .use(remarkRehype)
    .use(rehypeSlug)
    .use(rehypeHighlight, {
      languages: { r }
    })
    .use(rehypeStringify)
    .process(content);
  
  const headingRegex = /<(h[1-6]) id="(.+?)">(.+?)<\/\1>/g;
  let match;
  while ((match = headingRegex.exec(processedContent.toString())) !== null) {
    toc.push({
      text: match[3],
      id: match[2],
      level: parseInt(match[1][1], 10),
    });
  }
  const contentHtml = processedContent.toString();

  return (
    <div>
      <Cover />
      {/** mobile */}
      <div className="mt-12 md:hidden">
        <div className="mx-auto w-11/12">
          <div className="text-4xl font-bold">{frontMatter.title}</div>
          <div className="text-sm text-slate-600">
            Updated at: {frontMatter.updated_at} | Created at: {frontMatter.updated_at}
          </div>
          <div className="my-5 p-4 rounded-lg border shadow-lg bg-slate-100">
            <div className="font-bold">目次</div>
            <ul>
              {toc.map((heading, index) => (
                <li key={index} style={{ marginLeft: (heading.level - 1) * 16 }}>
                  <a href={`#${heading.id}`}>{heading.text}</a>
                </li>
              ))}
            </ul>
          </div>
          <div dangerouslySetInnerHTML={{ __html: contentHtml }} className="prose prose-lg pt-5 border-t-2"></div>
        </div>
      </div>
      {/** tablet, pc */}
      <div className="md:flex justify-center space-x-24 mx-auto mt-12 container hidden">
        <div className="md:w-2/3 lg:w-fit">
          <div className="mb-5">
            <div className="text-4xl font-bold">{frontMatter.title}</div>
            <div className="text-sm text-slate-600">
              Updated at: {frontMatter.updated_at} | Created at: {frontMatter.created_at}
            </div>
          </div>
          <div dangerouslySetInnerHTML={{ __html: contentHtml }} className="prose prose-lg"></div>
        </div>
        <div className="w-1/3 text-slate-700">
          <div className="sticky top-0">
            <div className="font-bold text-black">目次</div>
            <ul>
              {toc.map((heading, index) => (
                <li key={index} style={{ marginLeft: (heading.level - 1) * 16 }}>
                  <a href={`#${heading.id}`}>{heading.text}</a>
                </li>
              ))}
            </ul>
            <div className="mt-8">
              <div className="font-bold">関連記事</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
