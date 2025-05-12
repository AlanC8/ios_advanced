import axios from 'axios';
import fs from 'fs';
import path from 'path';
import { LOGOS } from '../cars/brand-logos';

// поправь список если нужно
const brandsWanted = [
  'bmw','hyundai','chevrolet','kia','toyota','lexus','nissan','honda','mazda',
  'mercedes','audi','volkswagen','skoda','lada','haval','chery','geely','jac',
  'peugeot','renault','ford','mitsubishi','subaru','tesla','porsche'
];

type CQ = { model_name: string; model_year: string; model_trim: string };

const fetchModels = async (make: string) => {
  const { data } = await axios.get('https://www.carqueryapi.com/api/0.3/', {
    params: { cmd: 'getModels', make, year: 1980, callback: '?' },
  });
  return (JSON.parse(data.replace(/^[^(]+\(|\);?$/g, '')) as { Models: CQ[] }).Models;
};

const group = <T, K extends string>(arr: T[], fn: (i: T) => K) =>
  arr.reduce((acc, cur) => ((acc[fn(cur)] ||= []).push(cur), acc), {} as Record<K, T[]>);

(async () => {
  console.log('🚀  CarQuery fetch...');
  const brands: any[] = [];

  for (const make of brandsWanted) {
    console.log(' ⏬', make);
    const models = await fetchModels(make);

    const bySeries = group(models, m => m.model_name.split(' ')[0]); // 1-е слово
    const seriesArr = Object.entries(bySeries).map(([seriesName, arr]) => {
      const byGen = group(arr, x => x.model_trim || `${Math.floor(+x.model_year / 10) * 10}s`);
      const generations = Object.entries(byGen).map(([code, gArr]) => {
        const years = gArr.map(x => +x.model_year);
        return { code: code || null, start: Math.min(...years), end: Math.max(...years) };
      });
      return { name: seriesName, generations };
    });

    brands.push({
      name: make.toUpperCase(),
      country: '—',
      logo: LOGOS[make.toUpperCase()] ?? '',
      series: seriesArr,
    });
  }

  const file = path.join(__dirname, '..', '..', 'wheelix_brands_seed.json');
  fs.writeFileSync(file, JSON.stringify({ brands, detailed: [] }, null, 2));
  console.log(`✅  Saved ${brands.length} brands → ${path.basename(file)}`);
})();
