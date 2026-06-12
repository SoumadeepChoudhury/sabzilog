import { motion } from "motion/react";
import { Users, Coins, History, CheckCircle2, TrendingUp, Zap } from "lucide-react";

export function Features() {
  const features = [
    {
      icon: <Users className="w-6 h-6 text-brand-primary" />,
      title: "Buyer Management",
      description: "Track all buyers from a single dashboard. Keep their contact info and transaction history organized in one place."
    },
    {
      icon: <Coins className="w-6 h-6 text-brand-primary" />,
      title: "Advance Tracking",
      description: "Record advances and adjust balances automatically. Never lose track of who has pre-paid for goods."
    },
    {
      icon: <CheckCircle2 className="w-6 h-6 text-brand-primary" />,
      title: "Due Settlement",
      description: "Know exactly who owes money and how much. Simply record settlements when payments arrive."
    },
    {
      icon: <History className="w-6 h-6 text-brand-primary" />,
      title: "Purchase History",
      description: "Maintain a complete history of every transaction. Easily reference past orders and amounts."
    },
    {
      icon: <TrendingUp className="w-6 h-6 text-brand-primary" />,
      title: "Cashflow Visibility",
      description: "Understand incoming and outgoing amounts instantly. Simple reports that make sense to your business."
    },
    {
      icon: <Zap className="w-6 h-6 text-brand-primary" />,
      title: "Simple & Fast",
      description: "Designed for everyday business owners. No complex accounting jargon, just the tools you need."
    }
  ];

  return (
    <section id="features" className="py-24 lg:py-32 relative z-10">
      <div className="max-w-7xl mx-auto px-6 lg:px-8">
        
        <div className="text-center max-w-3xl mx-auto mb-20">
          <motion.h2 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
            className="text-3xl md:text-5xl font-bold tracking-tight text-brand-text mb-6"
          >
            Everything you need.<br/> Nothing you don't.
          </motion.h2>
          <motion.p 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: 0.1 }}
            className="text-lg text-brand-text/70 leading-relaxed"
          >
            SabziLog is built specifically to address the challenges of managing small business ledgers, daily advances, and settlements.
          </motion.p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">
          {features.map((feature, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              whileHover={{ 
                y: -8, 
                backgroundColor: "var(--color-brand-card-hover)",
                boxShadow: "0 20px 40px -10px rgba(47,107,79,0.15)"
              }}
              className="glass-panel p-8 rounded-3xl transition-all duration-300 relative group overflow-hidden"
            >
              {/* Subtle hover gradient background */}
              <div className="absolute inset-0 bg-gradient-to-br from-brand-primary/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
              
              <div className="w-14 h-14 rounded-2xl bg-white shadow-sm border border-brand-primary/10 flex items-center justify-center mb-6 relative z-10 group-hover:scale-110 transition-transform duration-300">
                {feature.icon}
              </div>
              
              <h3 className="text-xl font-bold text-brand-text mb-3 relative z-10">
                {feature.title}
              </h3>
              
              <p className="text-brand-text/70 leading-relaxed text-sm relative z-10">
                {feature.description}
              </p>
            </motion.div>
          ))}
        </div>

      </div>
    </section>
  );
}
