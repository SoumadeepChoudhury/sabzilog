export function Terms() {
  return (
    <div className="pt-32 pb-20 max-w-4xl mx-auto px-6 lg:px-8 relative z-10 text-brand-text min-h-[80vh]">
      <div className="glass-panel p-8 md:p-12 rounded-[40px] shadow-sm">
        <h1 className="text-4xl md:text-5xl font-bold tracking-tight mb-8">Terms and Conditions</h1>
        <p className="mb-8 text-brand-text/70 font-medium tracking-wide text-sm">Last updated: {new Date().toLocaleDateString()}</p>
        
        <div className="space-y-8 text-brand-text/80 leading-relaxed">
          <section>
            <h2 className="text-2xl font-bold mb-4 text-brand-text">1. Acceptance of Terms</h2>
            <p>
              By downloading, installing, or using the SabziLog application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the application.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold mb-4 text-brand-text">2. Description of Service</h2>
            <p>
              SabziLog is a digital ledger and cashflow management utility designed for shop owners, vendors, and small business operators. It provides tools to record purchases, track advances, and monitor due settlements. SabziLog is not a substitute for professional accounting software or officially certified financial advice.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold mb-4 text-brand-text">3. User Responsibilities</h2>
            <p className="mb-4">
              As a user of SabziLog, you are responsible for:
            </p>
            <ul className="list-disc pl-6 space-y-2">
              <li>Maintaining the confidentiality of your account login credentials.</li>
              <li>Ensuring the accuracy of the financial data and buyer information you input.</li>
              <li>Using the application in compliance with local business laws and regulations.</li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold mb-4 text-brand-text">4. Limitation of Liability</h2>
            <p>
              While we strive to ensure top-tier reliability and continuous uptime, SabziLog is provided "as is." We are not liable for any direct, indirect, incidental, or consequential damages resulting from data loss, miscalculated ledgers, or business disruptions arising from the use of our application.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold mb-4 text-brand-text">5. Modifications and Updates</h2>
            <p>
              We reserve the right to update, modify, or discontinue any feature of SabziLog at any time. We will make reasonable efforts to notify users of significant changes, particularly regarding data handling or core functionalities.
            </p>
          </section>
        </div>
      </div>
    </div>
  );
}
