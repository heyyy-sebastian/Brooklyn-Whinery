require 'pg'

if ENV["RACK_ENV"] == "production"
    conn = PG.connect(
        dbname: ENV["POSTGRES_DB"],
        host: ENV["POSTGRES_HOST"],
        password: ENV["POSTGRES_PASS"],
        user: ENV["POSTGRES_USER"]
     )
else
    conn = PG.connect(dbname: "bk_whinery")
end

conn.exec("DROP TABLE if exists users CASCADE")
conn.exec("DROP TABLE if exists wines CASCADE")
conn.exec("DROP TABLE if exists menus CASCADE")
conn.exec("DROP TABLE if exists comments CASCADE")


conn.exec("CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    password_digest VARCHAR(255)
  )"
)

conn.exec("CREATE TABLE wines(
    id SERIAL PRIMARY KEY,
    year INTEGER,
    vineyard VARCHAR,
    color VARCHAR,
    type VARCHAR,
    mood VARCHAR,
    description TEXT
  )"
)

conn.exec("CREATE TABLE menus(
    id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES users(id),
    vote INTEGER DEFAULT 0,
    title VARCHAR,
    wine_a INTEGER REFERENCES wines(id),
    wine_b INTEGER REFERENCES wines(id),
    wine_c INTEGER REFERENCES wines(id),
    num_comments INTEGER DEFAULT 0
  )"
)

conn.exec("CREATE TABLE comments(
    id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES users(id),
    menu_id INTEGER REFERENCES menus(id),
    description TEXT
  )"
)


conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(1964, 'Chateau Margaux', 'red', 'Bordeaux', 'happy', 'A wine as confident as you are, you’ll see that it has deep ruby coloring with purple-black highlights, great viscosity, a beautiful bouquet of violets, jammy blackberry fruit, powerful structure, and great length.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2015, 'Domaine du Bagnol','red','rosé','happy', 'With a lingering finish of soft rounded fullness and aromatic hints of cocoa and orange zest, this rosé compliments any pleasant disposition.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(1998, 'Chateauneuf-du-Pape','red','Rhône','happy', 'The nose has very elegant and complex aromas, where one discovers notes of balsamic, flint, black fruit dessert and wild plum. The palate is dominated by ripe fruit, rich and balanced with lots of freshness. Pair with your favorite soft cheese for a spectacular evening.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(1984, 'Hedges Family Estate','red', 'Carbernet Sauvignon','happy', 'A dense yet harmonious herbal character of medium body, soft yet grippy, this wine will leave you feeling as smooth as its finish.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2010, 'Clos de Tart','red','Burgundy','happy', 'This wine is full of ripe, sophisticated tannins and plenty of fruit on the nose. Very classy fruit -- lots of style and flair, just like you!')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2012, 'La Azul','red', 'Malbec', 'sad', 'Already revealing some purple-black and ruby tones at the edge, the color is surprisingly evolved for a wine from this vintage; partake and feel your superiority evolve with the complexities of its colorings.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(1993,'Château de Chausse', 'red', 'Cabernet', 'sad', 'As if they took your childhood summers in Provence and bottled them, this rosé will change your mood from brooding to buoyant in just a few sips.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(1972, 'Castello di Ama','red', 'Chianti', 'sad', 'Stunning aromas and flavors of cassis, plum eau de vie and mulled blackberry fruit roll out, with notes of violet, pastis, apple wood and fruitcake all coursing through the dense finish. Consider the terrific grip that is thoroughly embedded as you consider the problems that are thoroughly embedded in your life.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2006, 'Porvenir', 'red', 'Pinot Noir', 'sad', 'The aromatics alone will be enough to distract you from your mundane existence -- contemplate the incredible aromas of dried flowers, beef blood, spice, figs, sweet black currants and kirsch, smoked game, lavender, and sweaty but attractive saddle leather-like notes as you imbibe.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(1987, 'Alma Rosa', 'red', 'Shiraz', 'sad', 'This wine presents splendid concentration and depth on the nose, complimenting a mood for deep contemplation. Real drive and dimension. Great class. Full body. Rich, vigorous, profound, and very lovely at the end.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2015, 'Arturo Vettori', 'white', 'Prosecco', 'happy', 'This is not simply a glass of prosecco, this wine is an experience. Transcendent notes of intense luminescence envelope you in a mellow fizz.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(1994, 'King Frosch', 'white', 'Reisling', 'happy', 'The closest approximation requires envisioning a liquefied charcoal grilled salmon heavily crusted on the outside, rose pink on the inside, sprinkled with Provencal herbs, and doused in lemon butter. Enjoy this symphony for your taste buds.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2010, 'Cloudy Bay Marlborough', 'white', 'Sauvignon Blanc', 'happy', 'Sweet and large-scaled, if a bit unrefined, this Sauvignon Blanc offers an unpredictable sensory experience with aromas of lemon curd and aggressive notes of spring.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(1982, 'Casarsa','white','Pinot Grigio','happy', 'In this wine you\’ll find the faintest soupçon of leeks and just a flutter of the finest chevre. Only the finest tastes for the finest sommeliers.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2006, 'Grgich Hills', 'white', 'Chardonnay','happy', 'Profound, mellow and opulent in character, this wine is the epitome of class.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(1974, 'Chateau Montelena', 'Pinot Gris', 'white', 'sad', 'This unctuous wine offers a rich, lush, intense mouthfeel with layers of concentrated, soft, velvety fruit.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2003, 'Frog\’s Leap', 'white', 'Chardonnay', 'sad', 'This dry Chardonnay has just a hint of tropical sweetness with notes of pineapple. Besides just fruit, you\’ll smell honeycomb and a chemical aroma similar to petrol. But don\’t worry -- it\’s just fuel for your burning hatred for mankind.' )")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2012, 'Laborum', 'white', 'Torrontes', 'sad', 'A swift, tangy finish and sour midtones to mirror your sour mood.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2015,'Pieropan','white', 'Prosecco', 'sad', 'You can taste the intense rays of sun that have been captured in the wine, but at the same time a good degree of acidity keeps the palette fresh. With luscious notes of crisp pears and apple and a mellow finish, this prosecco will leave you feeling refreshed and rejuvenated.')")
conn.exec("INSERT INTO wines(year, vineyard, color, type, mood, description) VALUES(2007, 'Prunetto','white', 'Moscato', 'sad', 'This indulgent wine is a silky white that offers ripe tropical fruit, dried apricot, lemon curd and smokey oak character with rich texture and a long, focused finish, allowing you to focus more fully on your personal woes.')")

