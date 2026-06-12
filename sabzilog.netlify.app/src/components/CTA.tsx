import { motion } from "motion/react";
import { Download } from "lucide-react";
import { useLatestRelease } from "../hooks/useLatestRelease";

export function CTA() {
  const downloadUrl = useLatestRelease();

  return (
    <section className="py-24 lg:py-32 relative overflow-hidden z-10">
      <div className="max-w-5xl mx-auto px-6 lg:px-8">
        <motion.div 
          initial={{ opacity: 0, y: 40 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-100px" }}
          transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
          className="relative rounded-[40px] overflow-hidden bg-white shadow-[0_20px_60px_rgba(47,107,79,0.08)] border border-brand-primary/10"
        >
          {/* Background Decor */}
          <div className="absolute top-0 right-0 w-64 h-64 bg-brand-primary/5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2 pointer-events-none" />
          <div className="absolute bottom-0 left-0 w-64 h-64 bg-emerald-400/10 rounded-full blur-3xl translate-y-1/2 -translate-x-1/2 pointer-events-none" />

          <div className="py-20 px-8 md:px-16 text-center flex flex-col items-center relative z-10">
            <h2 className="text-4xl md:text-5xl font-bold tracking-tight text-brand-text mb-6">
              Ready to Simplify Your <br/> Business Records?
            </h2>
            <p className="text-lg text-brand-text/70 mb-10 max-w-xl mx-auto">
              Download SabziLog today and keep every transaction organized. Available as an APK for your Android device.
            </p>
            
            <a 
              href={downloadUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="group"
            >
              <div className="relative inline-flex items-center justify-center gap-3 px-10 py-5 text-white transition-all bg-brand-text rounded-full shadow-lg overflow-hidden hover:scale-105 active:scale-95 duration-300">
                <div className="absolute inset-0 bg-gradient-to-r from-brand-primary to-emerald-600 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                <Download className="w-5 h-5 relative z-10" />
                <span className="font-semibold text-lg relative z-10">Download APK</span>
              </div>
            </a>
            
            <p className="text-xs font-medium text-brand-text/50 mt-6 tracking-wide uppercase">
              Requires Android 8.0 or later
            </p>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
