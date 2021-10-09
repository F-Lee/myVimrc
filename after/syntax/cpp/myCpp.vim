
" Qt Android
syn keyword qtNamespace QtAndroid
syn keyword qtClass QAndroidActivityResultReceiver
syn keyword qtClass QAndroidBinder
syn keyword qtClass QAndroidIntent
syn keyword qtClass QAndroidJniEnvironment
syn keyword qtClass QAndroidJniExceptionCleaner
syn keyword qtClass QAndroidJniObject
syn keyword qtClass QAndroidParcel
syn keyword qtClass QAndroidService
syn keyword qtClass QAndroidServiceConnection

" Qt Macros
syn keyword qtAccess mLog qDebug qWarning

" jni Type
syn keyword jniType jobject jclass jstring jthrowable jobjectArray jarray jbooleanArray jbyteArray jcharArray jshortArray jintArray jlongArray jfloatArray jdoubleArray
syn keyword jniType jboolean jbyte jchar jshort jint jlong jfloat jdouble

" Highlight
highlight link qtNamespace cppConstant
highlight link qtClass Type
highlight link qtMacro cDefine
highlight link qtAccess cppAccess
highlight link jniType Type
