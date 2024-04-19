import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  late CollectionReference ref;

  late DocumentReference docpath;

  ReadingApi(this.path) {
    ref = _db.collection(path);
  }

  // sentence

  Future<QuerySnapshot> getSentenceCollection() {
    return ref.doc('sentence').collection('sentence').get();
  }

  Stream<QuerySnapshot> streamSentenceCollection() {
    return ref
        .doc('zC780CHyBrJSv9ia9J3f')
        .collection('sentencecompletion')
        .snapshots();
  }

  Future<DocumentReference> addSentenceDocument(var data) {
    return ref
        .doc('zC780CHyBrJSv9ia9J3f')
        .collection('sentencecompletion')
        .add(data);
  }

  //true of false

  Future<QuerySnapshot> getTrueOrFalseCollection() {
    return ref.doc('trueorfalse').collection('trueorfalse').get();
  }

  Stream<QuerySnapshot> streamTrueOrFalseCollection() {
    print('Stream streamTrueOrFalseCollection:');
    return ref
        .doc('jEbRMedOEE7el5nGIr6x')
        .collection('trueorfalse')
        .snapshots();
  }

  Future<DocumentReference> addTrueOrFalseDocument(var data) {
    return ref.doc('trueorfalse').collection('trueorfalse').add(data);
  }

  // heading completion

  Future<QuerySnapshot> getHeadingCompletionCollection() {
    return ref.doc('headingcompletion').collection('headingcompletion').get();
  }

  Stream<QuerySnapshot> streamHeadingCompletionCollection() {
    return ref
        .doc('headingcompletion')
        .collection('headingcompletion')
        .snapshots();
  }

  Future<DocumentReference> addHeadingCompletionDocument(var data) {
    return ref
        .doc('headingcompletion')
        .collection('headingcompletion')
        .add(data);
  }

  // summary completion

  Future<QuerySnapshot> getSummaryCompletionCollection() {
    return ref.doc('summarycompletion').collection('summarycompletion').get();
  }

  Stream<QuerySnapshot> streamSummaryCompletionCollection() {
    return ref
        .doc('summarycompletion')
        .collection('summarycompletion')
        .snapshots();
  }

  Future<DocumentReference> addSummaryCompletionDocument(var data) {
    return ref
        .doc('summarycompletion')
        .collection('summarycompletion')
        .add(data);
  }

  // Paragraph

  Future<QuerySnapshot> getParagraphCompletionCollection() {
    return ref
        .doc('paragraphcompletion')
        .collection('paragraphcompletion')
        .get();
  }

  Stream<QuerySnapshot> streamParagraphCompletionCollection() {
    return ref
        .doc('paragraphcompletion')
        .collection('paragraphcompletion')
        .snapshots();
  }

  Future<DocumentReference> addParagraphCompletionDocument(var data) {
    return ref
        .doc('paragraphcompletion')
        .collection('paragraphcompletion')
        .add(data);
  }

  // MCQs

  Future<QuerySnapshot> getMCQsCollection() {
    return ref.doc('mcqs').collection('mcqs').get();
  }

  Stream<QuerySnapshot> streamMCQsCollection() {
    return ref.doc('mcqs').collection('mcqs').snapshots();
  }

  Future<DocumentReference> addMCQsDocument(var data) {
    return ref.doc('mcqs').collection('mcqs').add(data);
  }

  // List Selection

  Future<QuerySnapshot> getListSelectionCollection() {
    return ref.doc('listselection').collection('listselection').get();
  }

  Stream<QuerySnapshot> streamListSelectionCollection() {
    return ref.doc('listselection').collection('listselection').snapshots();
  }

  Future<DocumentReference> addListSelectionDocument(var data) {
    return ref.doc('listselection').collection('listselection').add(data);
  }

  // title Selection

  Future<QuerySnapshot> getTitleSelectionCollection() {
    return ref.doc('titleselection').collection('titleselection').get();
  }

  Stream<QuerySnapshot> streamTitleSelectionCollection() {
    return ref.doc('titleselection').collection('titleselection').snapshots();
  }

  Future<DocumentReference> addTitleSelectionDocument(var data) {
    return ref.doc('titleselection').collection('titleselection').add(data);
  }

  // categorization

  Future<QuerySnapshot> getCategorizationCollection() {
    return ref.doc('categorization').collection('categorization').get();
  }

  Stream<QuerySnapshot> streamCategorizationCollection() {
    return ref.doc('categorization').collection('categorization').snapshots();
  }

  Future<DocumentReference> addCategorizationDocument(var data) {
    return ref.doc('categorization').collection('categorization').add(data);
  }

  // ending Selection

  Future<QuerySnapshot> getEndingSelectionCollection() {
    return ref.doc('endingselection').collection('endingselection').get();
  }

  Stream<QuerySnapshot> streamEndingSelectionCollection() {
    return ref.doc('endingselection').collection('endingselection').snapshots();
  }

  Future<DocumentReference> addEndingSelectionDocument(var data) {
    return ref.doc('endingselection').collection('endingselection').add(data);
  }

  //saqs

  Future<QuerySnapshot> getSAQsCollection() {
    return ref.doc('saqs').collection('saqs').get();
  }

  Stream<QuerySnapshot> streamSAQsCollection() {
    return ref.doc('saqs').collection('saqs').snapshots();
  }

  Future<DocumentReference> addSAQsDocument(var data) {
    return ref.doc('saqs').collection('saqs').add(data);
  }
}
