import Link from "next/link";

const Landing = () => {
  return (
    <div>
      <section className="bg-gradient-to-br from-blue-500 to-purple-600 text-white py-12">
        <div className="container mx-auto px-4 text-center">
          <h1 className="text-3xl font-bold mb-4 md:text-5xl">
            Welcome to My Portfolio
          </h1>
          <p className="text-xl mb-8 md:text-2xl">
            I&apos;m a passionate developer creating amazing web experiences.
          </p>
          <Link href="/dev" className="bg-white text-blue-600 px-6 py-3
            rounded-full font-semibold hover:bg-gray-100 transition duration-300">
              View My Works
          </Link>
        </div>
      </section>
      <section className="pt-20">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center mb-6">Featured Blogs</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[1, 2, 3].map((blog) => (
              <div key={blog} className="bg-white rounded-lg shadow-md overflow-hidden">
                <div className="p-6">
                  <h3 className="text-xl font-semibold mb-2">Blog {blog}</h3>
                  <p className="text-gray-600 mb-4">A brief description of the blog and its key feature.</p>
                  <Link href={`/blogs/${blog}/`} className="text-blue-600 hover:underline">
                    Read More
                  </Link>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
    </div>
  );
};

export default Landing;