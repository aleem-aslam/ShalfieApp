import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedBooks() async {
  final firestore = FirebaseFirestore.instance;
  final booksCollection = firestore.collection('books');

  final List<Map<String, dynamic>> books = [
    {
      "title": "Deep Work",
      "author": "Cal Newport",
      "price": 8.75,
      "coverUrl": "https://studentstore.pk/cdn/shop/files/B_3.png?v=1730881977",
      "description":
          "Deep Work is a transformative guide that explores the rare ability to focus without distraction on cognitively demanding tasks. Cal Newport, a computer science professor and renowned productivity expert, explains why deep work has become increasingly valuable in a noisy digital world. He blends scientific insights with practical strategies, helping readers cultivate intense focus, minimize shallow distractions, and create meaningful, high-quality work. Newport’s research-driven approach empowers professionals, students, and creatives to reclaim their mental clarity and achieve exceptional results in their careers.",
      "category": "Non-fiction",
      "format": "pdf",
      "isbn": "9781455586691",
      "rating": 4.7,
    },

    {
      "title": "Think and Grow Rich",
      "author": "Napoleon Hill",
      "price": 7.50,
      "coverUrl": "https://studentstore.pk/cdn/shop/files/B_5.png?v=1730009553",
      "description":
          "Think and Grow Rich is Napoleon Hill’s legendary masterpiece on human potential and the psychology of wealth. Written after interviewing more than 500 of America’s most successful individuals, including Henry Ford and Thomas Edison, Hill reveals the mindset, habits, and principles that drive extraordinary achievement. His concepts—such as desire, faith, autosuggestion, persistence, and the mastermind—have shaped modern personal development for nearly a century. Hill’s teachings go beyond financial gain, offering a powerful roadmap for personal growth, discipline, and purpose. This timeless classic continues to inspire millions to unlock their inner potential and pursue meaningful success.",
      "category": "Classics",
      "format": "epub",
      "isbn": "9781585424337",
      "rating": 4.6,
    },

    {
      "title": "Harry Potter and the Sorcerer's Stone",
      "author": "J.K. Rowling",
      "price": 12.99,
      "coverUrl":
          "https://m.media-amazon.com/images/I/81iqZ2HHD-L._SL1500_.jpg",
      "description":
          "The first book in J.K. Rowling’s world-famous series introduces readers to Harry Potter, a young orphan who discovers he is a wizard. As Harry enters Hogwarts School of Witchcraft and Wizardry, he unravels mysteries about his past, forms lifelong friendships, and faces unexpected dangers. Rowling’s imaginative storytelling, emotional depth, and richly detailed world have captivated readers of all ages. The author, once a struggling writer, created a global cultural phenomenon that redefined fantasy literature and inspired generations. This magical beginning sets the stage for an unforgettable journey filled with courage, wonder, and destiny.",
      "category": "Fantasy",
      "format": "epub",
      "isbn": "9780590353427",
      "rating": 4.9,
    },

    {
      "title": "The Fault in Our Stars",
      "author": "John Green",
      "price": 9.50,
      "coverUrl":
          "https://www.libertybooks.com/image/cache/catalog/9780141345659-2-626x974.jpg?q6",
      "description":
          "The Fault in Our Stars is a deeply emotional novel by John Green, telling the story of Hazel Grace Lancaster, a witty teenager battling cancer, and Augustus Waters, a charming and thoughtful survivor. Their unexpected romance unfolds with humor, vulnerability, and profound insight into life’s fragility. John Green, celebrated for his heartfelt writing and sharp characterization, weaves themes of love, loss, philosophy, and human connection into a powerful narrative. Beyond being a tragic love story, the book explores what it means to live meaningfully, even when time feels limited. It remains one of the most moving young adult novels of its generation.",
      "category": "Young Adult",
      "format": "pdf",
      "isbn": "9780525478812",
      "rating": 4.7,
    },

    {
      "title": "The Shining",
      "author": "Stephen King",
      "price": 10.50,
      "coverUrl":
          "https://www.libertybooks.com/image/cache/catalog/9781444720723%201-626x974.jpg?q6",
      "description":
          "The Shining is one of Stephen King’s most celebrated psychological horror novels. It follows Jack Torrance, a struggling writer and recovering alcoholic who becomes the winter caretaker of the isolated Overlook Hotel. As the harsh winter traps the family inside, Jack’s sanity slowly unravels under the influence of supernatural forces. Stephen King, widely regarded as the master of horror, blends psychological tension with chilling paranormal elements. His deep exploration of addiction, family trauma, and inner demons makes this novel far more than a simple ghost story. It is a haunting exploration of human vulnerability and the darkness lurking within us.",
      "category": "Horror",
      "format": "epub",
      "isbn": "9780307743657",
      "rating": 4.5,
    },

    {
      "title": "The Girl with the Dragon Tattoo",
      "author": "Stieg Larsson",
      "price": 11.99,
      "coverUrl":
          "https://www.libertybooks.com/image/cache/catalog/9781529432398%201-626x974.jpg?q6",
      "description":
          "This gripping mystery thriller introduces readers to journalist Mikael Blomkvist and brilliant hacker Lisbeth Salander as they investigate the decades-old disappearance of a wealthy heiress. Stieg Larsson, a Swedish journalist and activist, wrote the novel as part of a trilogy that tackles corruption, abuse of power, and the complexities of justice. Larsson’s sharp narrative style and complex characters made the book an international bestseller. Lisbeth Salander, in particular, became an iconic figure in modern fiction for her intelligence, resilience, and depth. The novel blends dark secrets, investigative journalism, and psychological intrigue into a thrilling experience.",
      "category": "Crime",
      "format": "pdf",
      "isbn": "9780307454546",
      "rating": 4.4,
    },

    {
      "title": "Dune",
      "author": "Frank Herbert",
      "price": 14.99,
      "coverUrl":
          "https://www.libertybooks.com/image/cache/catalog/Dune%20new%20edition-626x974.jpg?q6",
      "description":
          "Dune is Frank Herbert’s groundbreaking science-fiction epic set on the desert planet Arrakis, the only source of the universe’s most valuable substance—melange. The story follows Paul Atreides, a young noble thrust into political betrayal, spiritual awakening, and an ancient prophecy that could reshape humanity. Herbert, known for his deep world-building and philosophical storytelling, weaves themes of ecology, religion, power, and destiny with extraordinary precision. Considered one of the greatest sci-fi novels ever written, Dune influenced generations of authors and filmmakers. Its rich mythology and visionary scope make it a masterpiece of speculative fiction.",
      "category": "Sci-fi",
      "format": "epub",
      "isbn": "9780441172719",
      "rating": 4.8,
    },
    {
      "title": "To Kill a Mockingbird",
      "author": "Harper Lee",
      "price": 8.99,
      "coverUrl":
          "https://www.libertybooks.com/image/cache/catalog/9781784870799%201-626x974.jpg?q6",
      "description":
          "Harper Lee’s Pulitzer Prize–winning classic explores racial injustice, moral courage, and childhood innocence in the American South during the 1930s. Through the eyes of young Scout Finch, readers witness her father, Atticus Finch, defend a Black man wrongly accused of a terrible crime. Lee, known for her simple yet powerful storytelling, illuminates themes of empathy, conscience, and human decency. The novel remains a profound reflection on prejudice, integrity, and the struggle for justice. Its characters and lessons continue to shape readers’ understanding of compassion and fairness across generations.",
      "category": "Classics",
      "format": "pdf",
      "isbn": "9780061120084",
      "rating": 4.8,
    },
    {
      "title": "The Great Gatsby",
      "author": "F. Scott Fitzgerald",
      "price": 7.99,
      "coverUrl": "https://m.media-amazon.com/images/I/81af+MCATTL.jpg",
      "description":
          "The Great Gatsby is Fitzgerald’s dazzling portrait of the Roaring Twenties—a world of ambition, glamour, and excess. Set against the backdrop of jazz, wealth, and idealism, the novel follows Jay Gatsby, a mysterious millionaire driven by love and longing for Daisy Buchanan. Fitzgerald, celebrated for his lyrical prose and cultural insight, captures the illusions of the American Dream with heartbreaking precision. This timeless novel explores desire, identity, betrayal, and the fragile line between fantasy and reality. It remains one of the most influential works of American literature.",
      "category": "Classics",
      "format": "epub",
      "isbn": "9780743273565",
      "rating": 4.4,
    },
    {
      "title": "The Alchemist",
      "author": "Paulo Coelho",
      "price": 9.25,
      "coverUrl": "https://m.media-amazon.com/images/I/71aFt4+OTOL.jpg",
      "description":
          "The Alchemist is Paulo Coelho’s internationally beloved tale of Santiago, a shepherd boy who dreams of finding treasure and discovering his personal destiny. Coelho, known for his spiritual wisdom and poetic writing, weaves themes of self-discovery, fate, courage, and the power of following one’s dreams. The story blends mysticism and philosophy, encouraging readers to trust their hearts and embrace the journey of life. With its universal message and uplifting tone, The Alchemist has inspired millions to pursue purpose, intuition, and meaning.",
      "category": "Fiction",
      "format": "epub",
      "isbn": "9780062315007",
      "rating": 4.6,
    },
    {
      "title": "Rich Dad Poor Dad",
      "author": "Robert T. Kiyosaki",
      "price": 10.99,
      "coverUrl": "https://m.media-amazon.com/images/I/81bsw6fnUiL.jpg",
      "description":
          "Rich Dad Poor Dad is Robert Kiyosaki’s groundbreaking personal finance book that contrasts the money lessons he learned from his educated but financially struggling father and his friend’s wealthy, entrepreneurial father. Kiyosaki empowers readers with principles about investing, financial freedom, asset-building, and escaping the paycheck-to-paycheck cycle. His practical yet thought-provoking narrative challenges traditional beliefs about work, money, and education. This book has become a global bestseller for its ability to simplify financial concepts and inspire readers to pursue wealth with confidence and strategy.",
      "category": "Non-fiction",
      "format": "pdf",
      "isbn": "9781612680194",
      "rating": 4.7,
    },
    {
      "title": "The Subtle Art of Not Giving a F*ck",
      "author": "Mark Manson",
      "price": 11.50,
      "coverUrl": "https://m.media-amazon.com/images/I/71QKQ9mwV7L.jpg",
      "description":
          "Mark Manson’s bold, humorous, and brutally honest approach to self-help redefines what it means to live a meaningful life. Instead of chasing constant positivity, Manson argues that embracing limitations, accepting responsibility, and choosing what truly matters are the keys to happiness. Drawing on philosophy, psychology, and personal experience, he delivers profound insights with a conversational, irreverent tone. The book challenges modern culture’s obsession with success, encouraging readers to prioritize values, resilience, and authenticity. A refreshing and transformative guide for today’s world.",
      "category": "Self-help",
      "format": "epub",
      "isbn": "9780062457714",
      "rating": 4.5,
    },
    {
      "title": "The Psychology of Money",
      "author": "Morgan Housel",
      "price": 13.25,
      "coverUrl": "https://m.media-amazon.com/images/I/71g2ednj0JL.jpg",
      "description":
          "Morgan Housel’s bestselling book explores how people think about money—often emotionally rather than logically. With a series of powerful stories, Housel explains that financial success is less about intelligence and more about behavior. He highlights the roles of luck, risk, humility, long-term thinking, and self-awareness in wealth building. Housel, a former Wall Street journalist and award-winning financial writer, communicates complex ideas with simplicity and elegance. His insights reshape the way readers approach investing, saving, spending, and understanding their own financial decisions.",
      "category": "Non-fiction",
      "format": "pdf",
      "isbn": "9780857197689",
      "rating": 4.8,
    },
    {
      "title": "The Hobbit",
      "author": "J.R.R. Tolkien",
      "price": 9.99,
      "coverUrl": "https://m.media-amazon.com/images/I/91b0C2YNSrL.jpg",
      "description":
          "The Hobbit is J.R.R. Tolkien’s enchanting prelude to The Lord of the Rings. The novel follows Bilbo Baggins, an ordinary hobbit thrust into an extraordinary adventure filled with dwarves, dragons, magic, and courage. Tolkien, a legendary linguist and myth-maker, crafted one of the most imaginative worlds in literature. His rich storytelling blends humor, bravery, friendship, and discovery. The book’s timeless charm and deep themes make it a beloved classic for readers of all ages, introducing them to Middle-earth’s vast and unforgettable mythology.",
      "category": "Fantasy",
      "format": "epub",
      "isbn": "9780547928227",
      "rating": 4.8,
    },
    {
      "title": "The Silent Patient",
      "author": "Alex Michaelides",
      "price": 12.00,
      "coverUrl":
          "https://www.libertybooks.com/image/cache/catalog/9781409181637-626x974.jpg?q6",
      "description":
          "The Silent Patient is a gripping psychological thriller about a famous painter, Alicia Berenson, who stops speaking after being accused of murdering her husband. Theo Faber, a psychotherapist, becomes obsessed with uncovering the truth behind her silence. Alex Michaelides, a screenwriter turned novelist, delivers a masterfully paced story filled with twists, emotional depth, and suspense. The novel explores trauma, obsession, and the complexities of the human mind. Its shocking conclusion and cinematic storytelling made it one of the most talked-about thrillers of the decade.",
      "category": "Thriller",
      "format": "pdf",
      "isbn": "9781250301697",
      "rating": 4.6,
    },
    {
      "title": "Sapiens: A Brief History of Humankind",
      "author": "Yuval Noah Harari",
      "price": 14.50,
      "coverUrl": "https://m.media-amazon.com/images/I/713jIoMO3UL.jpg",
      "description":
          "In Sapiens, historian Yuval Noah Harari explores the evolution of humankind from primitive hunter-gatherers to the rulers of the modern world. Harari, known for his deep intellect and narrative clarity, examines biology, culture, economics, and psychology to explain how Homo sapiens dominated the planet. His work challenges readers to rethink identity, progress, and the systems that shape human society. With bold insights and gripping storytelling, Sapiens has become a global phenomenon, provoking discussions about our past and our future as a species.",
      "category": "Non-fiction",
      "format": "epub",
      "isbn": "9780062316097",
      "rating": 4.7,
    },
    {
      "title": "The Da Vinci Code",
      "author": "Dan Brown",
      "price": 10.75,
      "coverUrl": "https://m.media-amazon.com/images/I/91Q5dCjc2KL.jpg",
      "description":
          "Dan Brown’s internationally bestselling thriller blends art, history, religion, and cryptography into a fast-paced mystery. When a murder occurs inside the Louvre, symbologist Robert Langdon and cryptologist Sophie Neveu uncover clues hidden in famous artworks. Brown, known for his meticulous research and cinematic storytelling, explores themes of faith, secrets, and the power of knowledge. The Da Vinci Code became a cultural sensation for its bold ideas and addictive narrative, inviting readers into a world of hidden codes and ancient conspiracies.",
      "category": "Thriller",
      "format": "epub",
      "isbn": "9780307474278",
      "rating": 4.4,
    },
    {
      "title": "The Power of Habit",
      "author": "Charles Duhigg",
      "price": 9.99,
      "coverUrl":
          "https://www.libertybooks.com/image/cache/catalog/9781400069286%201-626x974.jpg?q6",
      "description":
          "Charles Duhigg’s The Power of Habit reveals the science behind why habits form and how they can be changed. Drawing on research from neuroscience, psychology, and real-world case studies, Duhigg explains the Habit Loop and how organizations and individuals can transform behavior. Duhigg, a Pulitzer Prize–winning journalist, offers practical strategies to break bad routines and build powerful habits that lead to lasting success. His engaging storytelling makes complex science easy to understand and apply in everyday life.",
      "category": "Self-help",
      "format": "pdf",
      "isbn": "9780812981605",
      "rating": 4.6,
    },
    {
      "title": "The Fellowship of the Ring",
      "author": "J.R.R. Tolkien",
      "price": 13.99,
      "coverUrl":
          "https://www.libertybooks.com/image/cache/catalog/9633-626x974.jpg?q6",
      "description":
          "The Fellowship of the Ring begins Tolkien’s epic saga, The Lord of the Rings. The story follows Frodo Baggins, who inherits a mysterious ring with unimaginable power. Joined by a fellowship of heroes, he embarks on a dangerous quest to destroy the One Ring and prevent the rise of an ancient evil. Tolkien, a master storyteller and linguist, created one of the richest fantasy worlds ever written. His themes of friendship, sacrifice, courage, and destiny resonate deeply with readers around the world.",
      "category": "Fantasy",
      "format": "epub",
      "isbn": "9780547928210",
      "rating": 4.9,
    },
  ];

  final batch = firestore.batch();

  for (final book in books) {
    //book id auto generated
    final docRef = booksCollection.doc();
    batch.set(docRef, book);
  }

  await batch.commit();
  print('✅ Seeded ${books.length} books into Firestore.');
}
