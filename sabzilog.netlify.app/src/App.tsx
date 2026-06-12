/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import { BrowserRouter, Routes, Route } from "react-router-dom";
import { Navbar } from "./components/Navbar";
import { Footer } from "./components/Footer";
import { BackgroundEffects } from "./components/ui/BackgroundEffects";
import { Home } from "./pages/Home";
import { Privacy } from "./pages/Privacy";
import { Terms } from "./pages/Terms";
import { ScrollToHash } from "./components/ScrollToHash";

export default function App() {
  return (
    <BrowserRouter>
      <ScrollToHash />
      <main className="relative selection:bg-brand-primary/20 selection:text-brand-primary">
        <BackgroundEffects />
        <Navbar />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/privacy" element={<Privacy />} />
          <Route path="/terms" element={<Terms />} />
        </Routes>
        <Footer />
      </main>
    </BrowserRouter>
  );
}
