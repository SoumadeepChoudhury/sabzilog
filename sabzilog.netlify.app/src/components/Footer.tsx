import { Leaf } from "lucide-react";
import { Link } from "react-router-dom";

export function Footer() {
  return (
    <footer className="py-12 border-t border-brand-primary/10 bg-brand-background/50 backdrop-blur-sm">
      <div className="max-w-7xl mx-auto px-6 lg:px-8 flex flex-col md:flex-row items-center justify-between gap-6">
        <Link to="/" className="flex items-center gap-2 opacity-80 hover:opacity-100 transition-opacity">
          {/* <div className="flex items-center justify-center w-8 h-8 rounded-xl bg-brand-primary/10 text-brand-primary">
            <Leaf className="w-4 h-4 fill-current" />
          </div> */}
          <img src="logo.png" alt="" width={40} height={40} />
          <span className="text-lg font-bold tracking-tight text-brand-text">SabziLog</span>
        </Link>
        
        <div className="text-sm text-brand-text/60">
          &copy; {new Date().getFullYear()} SabziLog. All rights reserved.
        </div>
        
        <div className="flex gap-6 text-sm font-medium text-brand-text/60">
          <Link to="/privacy" className="hover:text-brand-primary transition-colors">Privacy</Link>
          <Link to="/terms" className="hover:text-brand-primary transition-colors">Terms</Link>
          <a href="https://github.com/SoumadeepChoudhury/sabzilog" className="hover:text-brand-primary transition-colors">GitHub</a>
        </div>
      </div>
    </footer>
  );
}
