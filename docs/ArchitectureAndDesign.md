
## Architecture and Design

### Logical Architecture:

#### Weddit Application:

- Weddit UI: our application's UI, allowing the users to consult articles and make comments, among other things;
- Profile Management logic:  service that manages and stores user profiles;
- Article Consultation logic: service that makes the bridge between our app and Wikipedia's UI;

#### External Services:

- Wikipedia Article API: the Wikipedia API for android application that allows access to the articles;

![LogicalArchitecture](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC04T2/blob/main/images/LogicalArchitecture.png)

### Physical architecture

#### Smartphone:

The potential user's smartphone, that contains:

- Weddit: our application;

#### Firebase Server:

The remote server serving as a storage for the information, that contains:

- Profile Database: stores all of the information that is displayed on each user's profile, i.e., the profile picture, description, name, saved posts, recent comments, etc;
- Comment Database: stores all of the comments relatives to each of the articles and the user who made them;

#### Wikipedia Server:

The remote server containing Wikipedia's articles, that contains:

- Article Database: database containing Wikipedia's articles, accessed by an API;

![PhysicalArchitecture](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC04T2/blob/main/images/PhysicalArchitecture.png)

