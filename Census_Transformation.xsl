<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/"> <!-- Template racine-->
        
        <!-- Page d'accueil -->
        <xsl:result-document href="index.html">
            <html lang="fr">
                <head>
                    <meta charset="UTF-8"/>
                    <title>
                        <xsl:value-of select="(//TEI)[1]/teiHeader/fileDesc/titleStmt/title/text()[1]"/> <!--Récupère le contenu textuel de la balise que lors de sa première apparition (sinon le titre serait présent en triple)-->
                        <xsl:value-of select="(//TEI)[1]/teiHeader/fileDesc/titleStmt/title/placeName"/> <!-- Ne récupère le titre que jusqu'à la fin de la balise <placeName></placeName>-->
                    </title>
                    <link rel="stylesheet" href="style.css"/> <!-- Appelle la feuille de style css -->
                </head>
                
                <body>
                    
                    <h1>
                        <xsl:value-of select="(//TEI)[1]/teiHeader/fileDesc/titleStmt/title/text()[1]"/>
                        <xsl:value-of select="(//TEI)[1]/teiHeader/fileDesc/titleStmt/title/placeName"/>
                    </h1>
                    
                    <div class="galerie"> <!-- Attribution HTML de la classe pour la "galerie" photo de la page d'accueil -->
                        <xsl:for-each select="//TEI"> <!-- On boucle sur chaque élément TEI pour récupérer le contenu -->
                            
                            <xsl:variable name="num" select="position()"/> <!-- Permet de savoir dans quel élément TEI de la boucle on est => d'autant plus important pour associer la bonne photo à la page -->
                            <xsl:variable name="cote"
                                select="teiHeader/fileDesc/sourceDesc//idno[@type='Cote']"/> <!-- On attribue chaque cote à chaque image -->
                            
                            <div class="registre">
                                <a href="page{$num}.html"> <!-- num créé en fonction de l'élément TEI dans lequel on est (le 1er, le 2e ou le 3e) -->
                                    <img src="img/Census_Register_Sample_{$num}.jpg" alt="Page extraite d'un registre de recensement de 1872 pour la ville de Tours - cote {$cote}"/> <!-- Ajout de l'image, avec un alt. Nommage semi-automatique du lien de photo -> on met juste le numéro de page à jour, mais la base du nom et le chemin sont définit en dur -->
                                </a>
                                <p><xsl:value-of select="$cote"/></p> <!-- Ajoute sous la photo la cote correspondante, en suivant l'ordre d'apparition des différentes cotes dans chaque élément TEI -->
                            </div>
                            
                        </xsl:for-each>
                    </div>
                    
                </body>
            </html>
        </xsl:result-document>
        
        <!-- pages -->
        <xsl:apply-templates select="//TEI"/> <!-- On vapplique le template à tous les éléments TEI  -->
        
    </xsl:template>
    
    
    <!-- Les pages -->
    <xsl:template match="TEI">
        
        <!-- Définition de toutes les variables qu'on appelera plus tard -->
        <xsl:variable name="num" select="position()"/>
        <xsl:variable name="titre" select="teiHeader/fileDesc/titleStmt/title"/>
        <xsl:variable name="pub" select="teiHeader/fileDesc/publicationStmt"/>
        <xsl:variable name="bibl" select="teiHeader/fileDesc/sourceDesc/biblStruct"/>
        <xsl:variable name="cote" select="teiHeader/fileDesc/sourceDesc//idno[@type='Cote']"/>
        <xsl:variable name="quartier" select=".//div[@place][1]/@place"/>
        
        <xsl:result-document href="page{$num}.html" method="html" indent="yes"> <!-- On attribue automatiquement la page à un numéro (dans l'ordre d'apparition de la balise <TEI></TEI> dans le fichier xml) -->
            <html lang="fr">
                <head>
                    <meta charset="UTF-8"/>
                    <title><xsl:value-of select="$titre"/></title> <!-- Cette fois on sélectionne toute la balise titre -->
                    <link rel="stylesheet" href="style.css"/>
                </head>
                
                <body>
                    
                    <h1><xsl:value-of select="$titre"/></h1>
                    
                    <p><a href="index.html">Retour</a></p> <!-- Bouton de retour pour retourner à la page d'accueil -->
                    
                    <div class="container">
                        
                        <!-- Élements de création du tableau -->
                        <table>
                            <tr> <!-- On définit les catégories -->
                                <th>Quartier</th>
                                <th>Ménage</th>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Rôle</th>
                                <th>Sexe</th>
                                <th>Statut</th>
                                <th>Âge</th>
                                <th>Nationalité</th>
                                <th>Naissance</th>
                                <th>Observations</th>
                            </tr>
                            
                            <!-- Remplissage du tableau -->
                            <xsl:for-each select=".//person"> <!-- On séléctionne toutes les personnes -->
                                
                                <!-- l'ajout de normalize-space ci dessous permet de normaliser, notamment en enlevant tous les espaces inutiles -->   
                                <tr>
                                    
                                    <td>
                                        <xsl:value-of select="$quartier"/> <!-- On sélection toutes les informations relatives au quartier -->
                                    </td>
                                    
                                    <td>
                                        <xsl:value-of select="ancestor::div[@subtype='numéroMénage'][1]/@n"/> <!-- On ne sélection que le numéro n du subtype numéroMénage  -->
                                    </td>
                                    
                                    <td>
                                        <xsl:for-each select="persName/surname"> <!-- On sélection les informations relatives au nom de famille -->
                                            
                                            <xsl:if test="@type='married'">
                                                <xsl:text> / </xsl:text> <!-- rajoute un séparateur quand nom d'épouse -->
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test="choice/corr"> <!-- Si forme corrigée, on ignore la transcription littérale en choice -->
                                                    <i>
                                                        <xsl:value-of select="normalize-space(choice/corr)"/>
                                                    </i>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="normalize-space(.)"/> <!-- Si pas de choix d'option, on met le seul nom -->
                                                </xsl:otherwise>
                                                
                                            </xsl:choose>
                                            
                                        </xsl:for-each>
                                    </td>
                                    
                                    <td>
                                        <xsl:value-of select="normalize-space(persName/forename)"/> <!-- On sélectionne le nom de famille -->
                                    </td>
                                    
                                    <td>
                                        <xsl:value-of select="@role"/> <!-- On sélectionne la valeur de l'attribu rôle de chacun -->
                                    </td>
                            
                                    <td>
                                        <xsl:value-of select="@sex"/> <!-- Même logique pour le sexe -->
                                    </td>
                                    
                                    <!-- statut -->
                                    <td>
                                        <xsl:value-of select="state[@type='role']/label"/> <!-- On sélectionne le contenu de la balise label, rangée dans la balise state avec attribut de role -->
                                    </td>
                                   
                                    <td>
                                        <xsl:value-of select="@age"/> <!-- Récupération de la valeur d'âge -->
                                    </td>
                                    
                                    <td>
                                        <xsl:value-of select="normalize-space(nationality)"/> <!-- Récupération de la nationalité -->
                                    </td>
                                    
                                    <!-- Récupération des informations de naissance. On ne garde que la version corrigée également -->
                                    <td>
                                        <xsl:choose>
                                            
                                            <!-- Si version corrigée -->
                                            <xsl:when test="birth/name/placeName/choice/corr">
                                                <i>
                                                    <xsl:value-of select="birth/name/placeName/choice/corr"/>
                                                </i>
                                            </xsl:when>
                                            
                                            <!-- Si pas de correction -->
                                            <xsl:otherwise>
                                                <xsl:value-of select="birth/name/placeName/text()"/>
                                            </xsl:otherwise>
                                            
                                        </xsl:choose>
                                    </td>
                                    
                                    <td>
                                        <xsl:value-of select="state[@type='observations']/label"/> <!-- Récupère ce qui est qualifié d'observations, si existe -->
                                    </td>
                                    
                                </tr>
                                
                            </xsl:for-each>
                            
                        </table>
                        
                        <p>
                            Nombre de personnes recensées: 
                            <xsl:value-of select="count(.//person)"/> <!-- Compte le nombre de personnes relevées par page -->
                        </p>
                        
                        <!-- Insertion de l'image dans chacune des pages -->
                        <div class="image-block">
                            
                            <img src="img/Census_Register_Sample_{$num}.jpg" alt="Page extraite d'un registre de recensement de 1872 pour la ville de Tours - cote {$cote}"/> <!-- Image + description alt. Nommage semi-automatique du lien de photo -> on met juste le numéro de page à jour, mais la base du nom et le chemin sont définit en dur -->
                            
                            <div class="legende"> <!--En guise de légende de l'image, on récupère et on normalise les informations contenues dans publicationStmt et bibilStruct -->
                                <p>
                                    <strong>Publication :</strong> <!-- Affiche en gras -->
                                    <xsl:value-of select="normalize-space(string($pub))"/> <!-- publicationStmt : on passe le contenu sélectionné en chane de caractères -->
                                </p>
                                <p>
                                    <strong>Source :</strong>
                                    <xsl:value-of select="normalize-space(string($bibl))"/> <!-- bibilStruct  -->
                                </p>
                            </div>
                            
                        </div>
                        
                    </div>
                    
                </body>
            </html>
        </xsl:result-document>
        
    </xsl:template>
    
</xsl:stylesheet>