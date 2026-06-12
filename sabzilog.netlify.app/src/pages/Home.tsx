import { Hero } from "../components/Hero";
import { Features } from "../components/Features";
import { Screenshots } from "../components/Screenshots";
import { CTA } from "../components/CTA";

export function Home() {
  return (
    <>
      <Hero />
      <Features />
      <Screenshots />
      <CTA />
    </>
  );
}
