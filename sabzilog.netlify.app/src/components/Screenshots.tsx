import { useRef } from "react";
import { motion, useScroll, useTransform } from "motion/react";

const SCREENSHOTS = [
  { id: 1, title: "Role Selection", src: "/screenshot1.png" },
  { id: 2, title: "Today's Logs", src: "/screenshot2.png" },
  { id: 3, title: "Monthly Report", src: "/screenshot3.png" },
  { id: 4, title: "Add Advance", src: "/screenshot4.png" },
];

export function Screenshots() {
  const containerRef = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ["start end", "end start"]
  });
  
  const y = useTransform(scrollYProgress, [0, 1], [100, -100]);

  return (
    <section id="preview" className="py-24 relative overflow-hidden" ref={containerRef}>
      
      {/* Dynamic Background */}
      <div className="absolute inset-0 bg-brand-text">
        <motion.div 
          style={{ y }}
          className="absolute inset-0 opacity-20"
        >
          <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-brand-primary rounded-full blur-[128px]" />
          <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-emerald-600 rounded-full blur-[128px]" />
        </motion.div>
      </div>

      <div className="max-w-7xl mx-auto px-6 lg:px-8 relative z-10 mb-16">
        <div className="text-center md:text-left">
          <h2 className="text-3xl md:text-5xl font-bold tracking-tight text-white mb-6">
            Beautifully crafted.<br />
            <span className="text-brand-text-light text-white/70">A joy to use daily.</span>
          </h2>
          <p className="text-lg text-white/60 max-w-xl md:mx-0 mx-auto">
            Swipe through to see SabziLog in action. Replace these placeholders with your actual app screenshots.
          </p>
        </div>
      </div>

      <div className="relative w-full overflow-x-auto no-scrollbar snap-x snap-mandatory flex gap-8 px-[10vw] pb-16 pt-8">
        {SCREENSHOTS.map((shot, index) => (
          <motion.div 
            key={shot.id}
            initial={{ opacity: 0, scale: 0.9 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ margin: "-100px" }}
            transition={{ duration: 0.5, delay: index * 0.1 }}
            className="shrink-0 snap-center first:pl-6 last:pr-6"
          >
            <div className="w-[280px] md:w-[320px] aspect-[9/19.5] relative rounded-[40px] border-[6px] border-[#2A2A2A] bg-black shadow-2xl group preserve-3d">
              {/* Phone notch */}
              <div className="absolute top-0 inset-x-0 h-6 flex justify-center z-50">
                <div className="w-1/2 h-[20px] bg-[#2A2A2A] rounded-b-[12px]" />
              </div>
              
              {/* Screen Content Image Placeholder */}
              <div className="w-full h-full rounded-[32px] overflow-hidden relative bg-[#F8F6F0]">
                {/* Replace src below with your actual screenshot images */}
                <img 
                  src={shot.src} 
                  alt={shot.title} 
                  className={`w-full h-full opacity-80 group-hover:opacity-100 group-hover:scale-105 transition-all duration-700 ease-out ${shot.id === 1 ? 'object-fill' : 'object-cover'}`}
                />
                
                {/* Simulated Glass Reflection Overlay */}
                <div className="absolute inset-0 bg-gradient-to-tr from-white/0 via-white/10 to-white/0 opacity-0 group-hover:opacity-100 transition-opacity duration-700 pointer-events-none" />
              </div>
            </div>
            
            <p className="text-center text-white/80 font-medium mt-8 text-sm tracking-wide">
              {shot.title}
            </p>
          </motion.div>
        ))}
      </div>
    </section>
  );
}
