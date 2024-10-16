"use client";

import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";

export default function EyeCatch() {
  const [isVisible, setIsVisible] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => setIsVisible(false), 3000);
    return () => clearTimeout(timer);
  }, []);

  const containerVariants = {
    hidden: { opacity: 1 },
    visible: { opacity: 1 },
    exit: { opacity: 0 },
  };
  const logoVariants = {
    hidden: { strokeDasharray: 1000, strokeDashoffset: 1000, fill: "rgba(255, 255, 255, 0)"},
    visible: {
      strokeDashoffset: 0,
      transition: {
        duration: 2,
        ease: "easeInOut",
      },
      fill: "rgba(255, 255, 255, 1)",
    },
  };
  const textVariants = {
    hidden: { opacity: 0, y: 20 },
    visible: { opacity: 1, y: 0 },
  };

  return (
    <AnimatePresence>
      {isVisible && (
        <motion.div
          className="fixed inset-0 z-50 flex items-center justify-center h-screen bg-gradient-to-br from-purple-600 to-blue-500"
          initial="hidden"
          animate="visible"
          exit="exit"
          variants={containerVariants}
          transition={{ duration: 1.0 }}
        >
          <div className="text-center">
            <motion.div
              initial="hidden"
              animate="visible"
              variants={logoVariants}
              transition={{
                type: "spring",
                stiffness: 250,
                damping: 20,
                delay: 0.5,
              }}
              className="mb-8"
            >
              <svg
                className="w-full h-24 text-white"
                viewBox="0 0 250 75"
                xmlns="http://www.w3.org/2000/svg"
              >
                <motion.text
                  x="50%"
                  y="50%"
                  dominantBaseline="middle"
                  textAnchor="middle"
                  fontSize="48"
                  fontWeight="bold"
                  fontFamily="Arial, sans-serif"
                  stroke="white"
                  strokeWidth="2"
                  fill="transparent"
                  variants={logoVariants}
                >
                  Hono
                </motion.text>
              </svg>
            </motion.div>
            <motion.div
              initial="hidden"
              animate="visible"
              variants={textVariants}
              transition={{ delay: 1.0, duration: 0.5 }}
            >
              <h1 className="text-4xl font-bold text-white mb-4">
                Welcome to My Site
              </h1>
              <p className="text-lg text-white">
                Discover amazing content and features
              </p>
            </motion.div>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}