import { motion } from "motion/react";
import { Download, ChevronRight } from "lucide-react";
import { Link } from "react-router-dom";
import { PhoneMockup } from "./ui/PhoneMockup";
import { useLatestRelease } from "../hooks/useLatestRelease";

export function Hero() {
  const downloadUrl = useLatestRelease();

  return (
    <section className="relative min-h-[100svh] pt-32 pb-20 flex items-center overflow-hidden">
      <div className="max-w-7xl mx-auto px-6 lg:px-8 w-full">
        <div className="grid lg:grid-cols-2 gap-16 lg:gap-8 items-center">
          
          {/* Left Side: Copy */}
          <div className="max-w-xl relative z-10">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
            >
              <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-brand-primary/10 text-brand-primary text-sm font-medium mb-6 border border-brand-primary/20 backdrop-blur-md">
                <span className="relative flex h-2 w-2">
                  <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-brand-primary opacity-75"></span>
                  <span className="relative inline-flex rounded-full h-2 w-2 bg-brand-primary"></span>
                </span>
                SabziLog for Android
              </div>
            </motion.div>

            <motion.h1 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.1, ease: [0.16, 1, 0.3, 1] }}
              className="text-5xl lg:text-7xl font-bold tracking-tight text-brand-text mb-6 text-balance leading-[1.1]"
            >
              Track Every Buyer.<br className="hidden lg:block"/> Manage Every Rupee.
            </motion.h1>

            <motion.p 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.2, ease: [0.16, 1, 0.3, 1] }}
              className="text-lg lg:text-xl text-brand-text/70 mb-10 text-balance max-w-lg leading-relaxed"
            >
              The modern ledger for shop owners. Track purchases, advances, settlements and dues with complete clarity.
            </motion.p>

            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.3, ease: [0.16, 1, 0.3, 1] }}
              className="flex flex-col sm:flex-row items-center gap-4"
            >
              <a 
                href={downloadUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="w-full sm:w-auto"
              >
                <div className="w-full sm:w-auto flex items-center justify-center gap-2 px-8 py-4 text-white transition-all bg-brand-primary rounded-full shadow-[0_8px_32px_rgba(47,107,79,0.3)] hover:shadow-[0_16px_48px_rgba(47,107,79,0.4)] hover:bg-brand-primary-light font-semibold text-lg hover:scale-105 active:scale-95">
                  <Download className="w-5 h-5" />
                  Download for Android
                </div>
              </a>
              <Link 
                to="/#features" 
                className="w-full sm:w-auto flex items-center justify-center gap-2 px-8 py-4 text-brand-text transition-all bg-white rounded-full shadow-sm hover:shadow-md font-medium text-lg border border-black/5 hover:bg-gray-50 active:scale-95"
              >
                View Features
                <ChevronRight className="w-5 h-5 text-brand-text/50" />
              </Link>
            </motion.div>
          </div>

          {/* Right Side: Phone & Floating Cards */}
          <div className="relative flex justify-center lg:justify-end items-center min-h-[600px]">
            {/* Ambient Background Glow */}
            <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-gradient-radial from-brand-primary/15 to-transparent rounded-full blur-3xl pointer-events-none" />
            
            <PhoneMockup />

            {/* Floating Glass Cards */}
            <motion.div
              animate={{ y: [-15, 15, -15], rotateZ: [-2, 2, -2] }}
              transition={{ duration: 8, repeat: Infinity, ease: "easeInOut" }}
              className="absolute top-[20%] right-[10%] lg:-right-4 glass-panel px-4 py-3 rounded-2xl z-20 shadow-xl hidden md:block"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-red-100 flex items-center justify-center text-red-600 font-bold">
                  ₹
                </div>
                <div>
                  <p className="text-xs text-brand-text/60 font-medium">Overdue</p>
                  <p className="text-base font-bold text-brand-text">₹12,450 Due</p>
                </div>
              </div>
            </motion.div>

            <motion.div
              animate={{ y: [15, -15, 15], rotateZ: [2, -2, 2] }}
              transition={{ duration: 9, repeat: Infinity, ease: "easeInOut", delay: 1 }}
              className="absolute bottom-[25%] left-[5%] lg:-left-12 glass-panel px-4 py-3 rounded-2xl z-20 shadow-xl hidden md:block"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-brand-primary/10 flex items-center justify-center text-brand-primary font-bold">
                  8
                </div>
                <div>
                  <p className="text-xs text-brand-text/60 font-medium">Network</p>
                  <p className="text-base font-bold text-brand-text">Active Buyers</p>
                </div>
              </div>
            </motion.div>

            <motion.div
              animate={{ y: [-10, 10, -10], x: [-5, 5, -5] }}
              transition={{ duration: 7, repeat: Infinity, ease: "easeInOut", delay: 2 }}
              className="absolute bottom-[10%] right-[15%] glass-panel px-4 py-3 rounded-2xl z-20 shadow-xl hidden md:block"
            >
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                  <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}><path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" /></svg>
                </div>
                <div>
                  <p className="text-sm font-bold text-brand-text">Settlement Completed</p>
                </div>
              </div>
            </motion.div>
          </div>
        </div>
      </div>
    </section>
  );
}
