import { motion } from "motion/react";

export function BackgroundEffects() {
  return (
    <div className="fixed inset-0 z-[-1] overflow-hidden pointer-events-none">
      {/* Soft radial ambient background glow */}
      <div className="absolute top-[-10%] left-[-10%] w-[50%] h-[50%] bg-brand-primary-light/10 rounded-full blur-[120px]" />
      <div className="absolute top-[20%] right-[-10%] w-[40%] h-[60%] bg-emerald-400/10 rounded-full blur-[140px]" />
      <div className="absolute bottom-[-10%] left-[20%] w-[60%] h-[40%] bg-teal-500/5 rounded-full blur-[100px]" />

      {/* Floating glass spheres */}
      <motion.div
        animate={{
          y: [0, -30, 0],
          x: [0, 15, 0],
          rotate: [0, 10, 0]
        }}
        transition={{
          duration: 8,
          repeat: Infinity,
          ease: "easeInOut"
        }}
        className="absolute top-[15%] right-[15%] w-32 h-32 rounded-full border border-white/40 bg-white/10 backdrop-blur-md shadow-[0_8px_32px_rgba(47,107,79,0.1)] hidden lg:block"
      />
      
      <motion.div
        animate={{
          y: [0, 40, 0],
          x: [0, -20, 0],
          rotate: [0, -15, 0]
        }}
        transition={{
          duration: 10,
          repeat: Infinity,
          ease: "easeInOut",
          delay: 2
        }}
        className="absolute bottom-[20%] left-[10%] w-24 h-24 rounded-full border border-white/40 bg-white/10 backdrop-blur-md shadow-[0_8px_32px_rgba(47,107,79,0.1)] hidden md:block"
      />
      
      <motion.div
        animate={{
          y: [0, -20, 0],
          scale: [1, 1.05, 1],
        }}
        transition={{
          duration: 7,
          repeat: Infinity,
          ease: "easeInOut",
          delay: 1
        }}
        className="absolute top-[40%] left-[5%] w-16 h-16 rounded-full border border-white/30 bg-brand-primary/5 backdrop-blur-lg shadow-sm hidden lg:block"
      />
    </div>
  );
}
