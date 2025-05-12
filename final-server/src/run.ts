import 'dotenv/config';
import mongoose from 'mongoose';
import Brand from './cars/models/Brand';
import Series from './cars/models/Series';
import Generation from './cars/models/Generation';
import fs from 'fs';
import path from 'path'

async function run() {
  await mongoose.connect('mongodb+srv://alan:1234@sw.blior6z.mongodb.net/ios-final');

  const data = JSON.parse(
    fs.readFileSync(
      path.join(__dirname, './', 'wheelix_brands_seed.json'), // ← вверх на один уровень
      'utf-8'
    )
  );

  // 1) бренды
  for (const b of data.brands) {
    await Brand.updateOne({ name: b.name }, { $set: b }, { upsert: true });
  }

  // 2) серии и поколения для тех, у кого они прописаны
  for (const b of data.detailed) {
    const brand = await Brand.findOne({ name: b.name });
    if (!brand) continue;

    for (const s of b.series) {
      const series = await Series.findOneAndUpdate(
        { brand: brand._id, name: s.name },
        { brand: brand._id, name: s.name },
        { upsert: true, new: true }
      );
      for (const g of s.generations) {
        await Generation.updateOne(
          { series: series._id, code: g.code },
          {
            series: series._id,
            code: g.code,
            years: { start: g.start, end: g.end },
          },
          { upsert: true }
        );
      }
    }
  }

  console.log('Seed complete ✅');
  process.exit(0);
}

run().catch((e) => {
  console.error(e);
  process.exit(1);
});
