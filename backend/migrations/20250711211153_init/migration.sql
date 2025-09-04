-- AlterTable
ALTER TABLE "_Post_tags" ADD CONSTRAINT "_Post_tags_AB_pkey" PRIMARY KEY ("A", "B");

-- DropIndex
DROP INDEX "_Post_tags_AB_unique";
