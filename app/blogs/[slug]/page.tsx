import fs from "fs";
import path from "path";
import matter from "gray-matter";
import { remark } from "remark";
import html from "remark-html";

interface Params {
  params: {
    slug: string;
  };
}

export default async function BlogPost({ params }: Params) {
  const { slug } = params;

  const markdownPath = path.join("blogs", slug, `${slug}.md`);
  const markdownWithMeta = fs.readFileSync(markdownPath, "utf-8");
  const { data: frontMatter, content } = matter(markdownWithMeta);

  const processedContent = await remark().use(html).process(content);
  const contentHtml = processedContent.toString();

  return (
    <div>
      <h1>{frontMatter.title}</h1>
      <div dangerouslySetInnerHTML={{ __html: contentHtml }}></div>
    </div>
  );
};
