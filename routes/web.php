<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request; 
use App\Models\ProcessSpy;

Route::get('/', function (Request $request) {  return "main is done"  })

Route::post('/zip', function (Request $request) {    
    if ($request->hasFile('file')) {
            $file = $request->file('file'); // الحصول على الملف
            $filename = Str::uuid() . '.' . $file->extension();
            $file->move(public_path('assets/uploads'), $filename);

        // فقط للعرض، لا يتم حفظه في قاعدة البيانات أو التخزين
        return response()->json([
            'message' => 'تم استلام الملف بنجاح',
            'filename' => $file->getClientOriginalName(),
            'mime' => $file->getClientMimeType()
        ]);
    } else {
        return response()->json(['message' => 'لم يتم إرسال ملف'], 400);
    }
});













Route::post('/postProcessRun', function (Request $request) {
    $Process = $request->getContent();
    ProcessSpy::where("Process",$Process)->update(['IsRun' => 'T', 'IsComplete' => 1 ]);  
    return "Run";
});
Route::post('/postProcessComplete', function (Request $request) {
    $Process = $request->getContent();
    ProcessSpy::where("Process",$Process)->update(['IsRun' => 'F', 'IsComplete' => 0 ]);  
    return $Process;
});



// GET
Route::get('/getProcess', function () { $IsRun = ProcessSpy::where("IsRun",'T')->first(); if($IsRun->IsRun = null) {return 0;} else {return $IsRun->Process;} });
















Route::get('/Getzip', function () {
$dir = public_path('assets/uploads/'); // اسم المجلد
$zipFile = 'downloads.zip'; // اسم ملف ZIP المؤقت
try{
// إنشاء ملف ZIP
$zip = new ZipArchive();
if ($zip->open($zipFile, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== true) {
    exit("لا يمكن إنشاء ملف ZIP\n");
}

// إضافة الملفات إلى ZIP
$files = glob($dir . '/*');
foreach ($files as $file) {
    if (is_file($file)) {
        $zip->addFile($file, basename($file));
    }
}
$zip->close();

// إرسال الملف للتحميل
header('Content-Type: application/zip');
header('Content-Disposition: attachment; filename="' . $zipFile . '"');
header('Content-Length: ' . filesize($zipFile));
readfile($zipFile);

// حذف الملفات الأصلية
foreach ($files as $file) {
    if (is_file($file)) {
        unlink($file);
    }
}

// حذف ملف ZIP المؤقت
unlink($zipFile);
exit;
}
catch(\Throwable $th)
{
    return $th;
}

});


