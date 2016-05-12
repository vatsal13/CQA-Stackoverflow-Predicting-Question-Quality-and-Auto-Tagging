from textblob import TextBlob
testimonial = TextBlob("not bad")
print testimonial.sentiment
print testimonial.sentiment.polarity