const functions = require("firebase-functions");
const axios = require("axios");
const cors = require("cors")({origin: true});

exports.getNews = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const apiKey = "29eb70dbe4dd46ac828638471d275d83";
      const apiUrl = `https://newsapi.org/v2/top-headlines?country=jp&apiKey=${apiKey}`;

      const response = await axios.get(apiUrl);
      const newsData = response.data;

      res.json(newsData);
    } catch (e) {
      console.error("エラー:", e);
      res.status(500).send("ニュースの取得に失敗しました");
    }
  });
});

exports.getNewsByQuery = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const query = req.query.q;
      console.log("Query:", query);
      const apiKey = "29eb70dbe4dd46ac828638471d275d83";
      const apiUrl = `https://newsapi.org/v2/everything?q=${query}&apiKey=${apiKey}`;
      const response = await axios.get(apiUrl);
      const newsData = response.data;
      console.log("News Data:", newsData);

      res.json(newsData);
    } catch (e) {
      console.error("エラー:", e);
      res.status(500).send("ニュースの取得に失敗しました");
    }
  });
});
