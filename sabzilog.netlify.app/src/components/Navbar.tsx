import { motion } from "motion/react";
import { Download, Leaf } from "lucide-react";
import { Link } from "react-router-dom";
import { useLatestRelease } from "../hooks/useLatestRelease";

export function Navbar() {
  const downloadUrl = useLatestRelease();

  return (
    <motion.nav
      initial={{ y: -20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
      className="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 py-4 mx-auto max-w-7xl lg:px-8 lg:py-6"
    >
      <Link to="/" className="flex items-center gap-2">
        {/* <div className="flex items-center justify-center w-10 h-10 rounded-2xl bg-brand-primary text-white shadow-lg shadow-brand-primary/20">
          <Leaf className="w-5 h-5 fill-current" />
        </div> */}
        <img src="logo.png" alt="Logo" width={40} height={40} />
        <span className="text-xl font-bold tracking-tight text-brand-text">SabziLog</span>
      </Link>

      <div className="hidden md:flex items-center gap-8 text-sm font-medium">
        <Link to="/#features" className="text-brand-text/70 hover:text-brand-primary transition-colors">Features</Link>
        <Link to="/#preview" className="text-brand-text/70 hover:text-brand-primary transition-colors">Preview</Link>
      </div>

      <div className="flex items-center">
        <a
          href={downloadUrl}
          target="_blank"
          rel="noopener noreferrer"
        >
          <motion.div
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            className="flex items-center gap-2 px-5 py-2.5 text-sm font-medium text-white transition-all bg-brand-primary rounded-full shadow-lg shadow-brand-primary/30 hover:shadow-brand-primary/50 hover:bg-brand-primary-light"
          >
            Download
            <Download className="w-4 h-4" />
          </motion.div>
        </a>
      </div>
    </motion.nav>
  );
}
