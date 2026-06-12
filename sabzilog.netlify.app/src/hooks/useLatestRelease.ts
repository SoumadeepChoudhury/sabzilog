import { useState, useEffect } from 'react';

// Cache the result to avoid hitting the API rate limit across multiple components
let globalDownloadUrl = "https://github.com/SoumadeepChoudhury/sabzilog/releases/latest";
let isFetched = false;
let fetchPromise: Promise<string> | null = null;

export function useLatestRelease() {
  const [downloadUrl, setDownloadUrl] = useState<string>(globalDownloadUrl);

  useEffect(() => {
    if (isFetched) {
      setDownloadUrl(globalDownloadUrl);
      return;
    }

    if (!fetchPromise) {
      fetchPromise = fetch('https://api.github.com/repos/SoumadeepChoudhury/sabzilog/releases/latest')
        .then(res => res.ok ? res.json() : null)
        .then(data => {
          if (data) {
            // Find the first asset that ends with .apk
            const apkAsset = data.assets?.find((asset: any) => asset.name.endsWith('.apk'));
            if (apkAsset) {
              globalDownloadUrl = apkAsset.browser_download_url;
            } else if (data.html_url) {
              // Fallback to the release page if no APK is found
              globalDownloadUrl = data.html_url;
            }
          }
          isFetched = true;
          return globalDownloadUrl;
        })
        .catch(err => {
          console.error("Failed to fetch GitHub release:", err);
          isFetched = true;
          return globalDownloadUrl;
        });
    }

    fetchPromise.then(url => {
      setDownloadUrl(url);
    });
  }, []);

  return downloadUrl;
}
