export function Privacy() {
  return (
    <div className="pt-32 pb-20 max-w-4xl mx-auto px-6 lg:px-8 relative z-10 text-brand-text min-h-[80vh]">
      <div className="glass-panel p-8 md:p-12 rounded-[40px] shadow-sm">
        <h1 className="text-4xl md:text-5xl font-bold tracking-tight mb-8">Privacy Policy</h1>
        <p className="mb-8 text-brand-text/70 font-medium tracking-wide text-sm">Last updated: {new Date().toLocaleDateString()}</p>
        
        <div className="space-y-8 text-brand-text/80 leading-relaxed">
          <section>
            <h2 className="text-2xl font-bold mb-4 text-brand-text">1. Information We Collect</h2>
            <p className="mb-4">
              SabziLog collects information necessary to provide our digital ledger services. This includes:
            </p>
            <ul className="list-disc pl-6 space-y-2">
              <li>Account information (name, email address, phone number).</li>
              <li>Business data (transaction logs, buyer records, due tracking amounts).</li>
              <li>Device information and usage statistics to improve application performance.</li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold mb-4 text-brand-text">2. How We Use Your Data</h2>
            <p className="mb-4">
              The primary purpose of collecting your data is to offer a reliable and robust ledger tracking experience. We use the information to:
            </p>
            <ul className="list-disc pl-6 space-y-2">
              <li>Facilitate real-time tracking of advances, settlements, and purchase history.</li>
              <li>Authenticate your login and securely encrypt your local logs.</li>
              <li>Send critical alerts, account updates, and system notifications.</li>
              <li>Enhance, monitor, and debug our Android application.</li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold mb-4 text-brand-text">3. Data Security</h2>
            <p>
              We implement industry-standard encryption and robust security measures to protect your financial and business data from unauthorized access. Your ledger data is considered highly confidential and is processed strictly for the functionality of the SabziLog application.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold mb-4 text-brand-text">4. Sharing of Information</h2>
            <p>
              We do not sell, rent, or trade your personal or business data to third parties. We may only share your data with trusted infrastructure providers necessary for the app to function (e.g., database hosting) under strict confidentiality agreements.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold mb-4 text-brand-text">5. Your Rights</h2>
            <p>
              You have the right to access, modify, or permanently delete your financial data from SabziLog. You can initiate a data deletion request directly from within the application's settings or by contacting our support team.
            </p>
          </section>
        </div>
      </div>
    </div>
  );
}
