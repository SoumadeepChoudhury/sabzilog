import { motion } from "motion/react";
import { Bell, User, ShoppingBag, CreditCard, ChevronRight } from "lucide-react";

export function PhoneMockup() {
  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.9, y: 40 }}
      animate={{ opacity: 1, scale: 1, y: 0 }}
      transition={{ duration: 1, ease: [0.16, 1, 0.3, 1], delay: 0.2 }}
      className="relative w-[320px] h-[650px] mx-auto z-10"
    >
      {/* 3D Device Frame effect via layered shadows and borders */}
      <motion.div 
        animate={{
          y: [-10, 10, -10],
          rotateX: [2, -2, 2],
          rotateY: [-4, 4, -4],
        }}
        transition={{
          duration: 12,
          repeat: Infinity,
          ease: "easeInOut"
        }}
        style={{ perspective: 1000 }}
        className="w-full h-full"
      >
        <div className="relative w-full h-full rounded-[44px] border-[8px] border-[#1C1C1E] bg-[#1C1C1E] shadow-[0_32px_80px_rgba(47,107,79,0.25),inset_0_0_0_2px_rgba(255,255,255,0.15)] ring-1 ring-black/10 overflow-hidden transform-gpu preserve-3d">
          
          {/* Top Notch Area */}
          <div className="absolute top-0 inset-x-0 h-6 flex justify-center z-50">
            <div className="w-[120px] h-[24px] bg-[#1C1C1E] rounded-b-[16px] relative flex justify-center items-center">
               <div className="w-12 h-1.5 rounded-full bg-black/50 backdrop-blur-sm self-start mt-1 mr-2" />
               <div className="w-2.5 h-2.5 rounded-full bg-[#1C1C1E] shadow-[inset_0_1px_2px_rgba(255,255,255,0.2)] ml-1 border border-white/5" />
            </div>
          </div>

          {/* Screen Content - Screenshot Image */}
          <div className="w-full h-full bg-[#F5F3EC] overflow-hidden flex flex-col relative rounded-[36px]">
            <img 
              src="/screenshot2.png" 
              alt="Today's Logs Screenshot" 
              className="w-full h-full object-cover"
            />
          </div>
          
          {/* Edge Reflections for Phone screen */}
          <div className="absolute inset-0 rounded-[36px] ring-inner ring-1 ring-white/20 pointer-events-none" />
          <div className="absolute inset-x-0 top-0 h-1/4 bg-gradient-to-b from-white/10 to-transparent pointer-events-none" />
        </div>
      </motion.div>
    </motion.div>
  );
}
